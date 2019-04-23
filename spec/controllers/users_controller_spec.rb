# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user) }
  let(:project) { create(:project) }
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
    it '401s unless signed in' do
      sign_out user
      get :dashboard
      expect(response.status).to eq(401)
    end
  end

  describe 'tasks' do
    render_views
    it 'displays tasks available according to users role in a project' do
      sign_in user
      user_registry.roles << role
      user_registry.save!

      get :tasks, params: { project_id: project.noid }
      expect(response.body).to include("Actions for #{project.title} - #{role.designation.to_s.capitalize}")
    end

    it '401s unless signed in' do
      sign_out user
      get :tasks, params: { project_id: '1' }
      expect(response.status).to eq(401)
    end
  end
end
