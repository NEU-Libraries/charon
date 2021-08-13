# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin) }
  let(:project) { FactoryBot.create_for_repository(:project) }

  describe 'show' do
    render_views
    it 'shows the user\'s profile' do
      # TODO: actually flesh out partial and testing
      sign_in user
      get :show, params: { id: user.id }
      expect(CGI.unescapeHTML(response.body)).to include(user.last_name)
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
      expect(CGI.unescapeHTML(response.body)).to include('No projects available')
    end

    it 'redirects to actions if there is only one project' do
      sign_in user
      project.attach_user(user)
      get :dashboard
      expect(response).to redirect_to(actions_path(project))
    end

    it 'shows all projects if the user is an administrator' do
      first_project = FactoryBot.create_for_repository(:project)
      second_project = FactoryBot.create_for_repository(:project)
      sign_in admin_user
      get :dashboard
      expect(response).to render_template('users/dashboard')
      expect(CGI.unescapeHTML(response.body)).to include(first_project.title)
      expect(CGI.unescapeHTML(response.body)).to include(second_project.title)
    end
  end

  describe 'actions' do
    render_views
    it 'displays actions available according to users role in a project' do
      sign_in user
      project.attach_user(user)
      get :actions, params: { id: project.noid }
      expect(CGI.unescapeHTML(response.body)).to include("Actions for #{project.title} - #{project.roles.first.designation.to_s.capitalize}")
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
      sign_in user
      get :new_user
      expect(CGI.unescapeHTML(response.body)).to include('Create a user')
    end
  end

  describe 'create_user' do
    it 'creates a user and emails them a notification' do
      sign_in user
      post :create_user, params: { id: project.noid, user: { email: 'test@email.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].to_s).to eq('test@email.com')
    end
  end

  describe 'edit' do
    render_views
    it 'displays the user form' do
      sign_in user
      get :edit, params: { id: user.id }
      expect(CGI.unescapeHTML(response.body)).to include(user.last_name)
    end
  end

  describe 'update' do
  end
end
