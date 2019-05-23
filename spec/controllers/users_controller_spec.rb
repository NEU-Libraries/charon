# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user) }
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:user_registry) { UserRegistry.find(project.user_registry_id) }
  let(:role) { build(:role, user: user, user_registry: user_registry) }

  describe 'index' do
    render_views
    it 'displays the user' do
      sign_in user
      get :index
      expect(response.body).to include(user.last_name)
    end
    it '401s unless signed in' do
      sign_out user
      get :index
      expect(response.status).to eq(401)
    end
  end

  describe 'dashboard' do
    render_views
    it '401s unless signed in' do
      sign_out user
      get :dashboard
      expect(response.status).to eq(401)
    end

    it 'informs the user if there are no projects to select' do
      sign_in user
      get :dashboard
      expect(response.body).to include('No projects available')
    end

    it 'redirects to actions if there is only one project' do
      sign_in user
      user_registry.roles << role
      user_registry.save!
      get :dashboard
      expect(response).to redirect_to(actions_path(project.noid))
    end
  end

  describe 'actions' do
    render_views
    it 'displays actions available according to users role in a project' do
      sign_in user
      if user_registry.roles.blank?
        user_registry.roles << role
        user_registry.save!
      end
      get :actions, params: { id: project.noid }
      expect(response.body).to include("Actions for #{project.title} - #{role.designation.to_s.capitalize}")
    end

    it '401s unless signed in' do
      sign_out user
      get :actions, params: { id: '1' }
      expect(response.status).to eq(401)
    end
  end

  describe 'new_user' do
    render_views
    it 'renders new user form' do
      sign_in FactoryBot.create(:user)
      get :new_user
      expect(response.body).to include('Create a user')
    end
  end

  describe 'create_user' do
    it 'creates a user and emails them a notification' do
      sign_in FactoryBot.create(:user)
      post :create_user, params: { id: project.noid, user: { email: 'test@email.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].to_s).to eq('test@email.com')
    end
  end
end
