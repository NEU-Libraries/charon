# frozen_string_literal: true

require 'rails_helper'

describe AdminController do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin) }

  describe 'dashboard' do
    it '401s unless signed in' do
      get :dashboard
      expect(response.status).to eq(401)
    end

    it '403s unless user is an admin' do
      sign_in user
      get :dashboard
      expect(response.status).to eq(403)
    end

    it '200s if admin is logged in' do
      sign_in admin_user
      get :dashboard
      expect(response.status).to eq(200)
    end
  end

  describe 'delete_users' do
    it 'removes users' do
      sign_in admin_user
      user_ids = []
      # create users
      3.times do
        u = User.create(password: Devise.friendly_token.first(10),
                        email: Faker::Internet.email,
                        first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name)
        user_ids << u.id
      end
      expect(user_ids.length).to be 3
      # delete users
      post :delete_users, params: { user_ids: user_ids }
      # expect to find them gone
      user_ids.each do |id|
        expect { User.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'new_user' do
    render_views
    it 'renders new user form' do
      sign_in admin_user
      get :new_user
      expect(CGI.unescapeHTML(response.body)).to include('Create a user')
    end
  end

  describe 'create_user' do
    it 'creates a user and emails them a notification' do
      sign_in admin_user
      post :create_user, params: { user: { email: 'test@email.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].to_s).to eq('test@email.com')
    end

    it 'does not create a user when their email is already in use' do
      User.create(password: 'password', email: 'email@alreadyinuse.com', first_name: 'Test', last_name: 'Test')
      sign_in admin_user
      post :create_user, params: { user: { email: 'email@alreadyinuse.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      expect(response).to redirect_to(root_path)
    end
  end
end
