# frozen_string_literal: true

require 'rails_helper'

describe AdminController do
  describe 'dashboard' do
    it '401s unless signed in' do
      get :dashboard
      expect(response.status).to eq(401)
    end

    it '403s unless user is an admin' do
      sign_in FactoryBot.create(:user)
      get :dashboard
      expect(response.status).to eq(403)
    end
  end

  describe 'new_user' do
    render_views
    it 'renders new user form' do
      sign_in FactoryBot.create(:admin)
      get :new_user
      expect(CGI.unescapeHTML(response.body)).to include('Create a user')
    end
  end

  describe 'create_user' do
    it 'creates a user and emails them a notification' do
      sign_in FactoryBot.create(:admin)
      post :create_user, params: { user: { email: 'test@email.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].to_s).to eq('test@email.com')
    end

    it 'does not create a user when their email is already in use' do
      User.create(password: 'password', email: 'email@alreadyinuse.com', first_name: 'Test', last_name: 'Test')
      sign_in FactoryBot.create(:admin)
      post :create_user, params: { user: { email: 'email@alreadyinuse.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      response.should redirect_to '/'
    end
  end
end
