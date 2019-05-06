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
      user_registry.project_id = project.id
      user_registry.roles << role
      user_registry.save!
      user_registry.reload
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
      get :actions, params: { project_id: project.noid }
      expect(response.body).to include("Actions for #{project.title} - #{role.designation.to_s.capitalize}")
    end

    it '401s unless signed in' do
      sign_out user
      get :actions, params: { project_id: '1' }
      expect(response.status).to eq(401)
    end
  end
end
