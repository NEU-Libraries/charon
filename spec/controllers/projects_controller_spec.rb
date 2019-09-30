# frozen_string_literal: true

require 'rails_helper'

describe ProjectsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin) }

  describe 'new' do
    render_views
    it 'renders the new record form' do
      sign_in admin_user
      get :new
      expect(response).to render_template('projects/new')
    end
  end

  describe 'create' do
    context 'with valid input' do
      it 'creates a project' do
        sign_in admin_user
        post :create, params: { project: { title: 'Cat', description: 'In the hat' } }
        expect(assigns(:project).title).to eq('Cat')
      end
    end
  end

  describe 'users' do
    render_views
    it 'lists attached users for a given project' do
      project.attach_user(user, Designation.manager)
      sign_in user
      get :users, params: { id: project.noid }
      expect(CGI.unescapeHTML(response.body)).to include("User Registry for #{project.title}")
      # TODO: need to flesh this out by actually populating and looking for users
    end
  end

  describe 'new_user' do
    render_views
    it 'renders the new user form' do
      project.attach_user(user, Designation.manager)
      sign_in user
      get :new_user, params: { id: project.noid }
      expect(response).to render_template('shared/new_user')
    end
  end

  describe 'sort_column' do
    render_views
    it 'returns designation unless there is a value for params[:sort]' do
      project.attach_user(user, Designation.manager)
      sign_in user
      get :users, params: { id: project.noid, sort: 'users.last_name' }
      expect(CGI.unescapeHTML(response.body)).to include('Last Name ▾')
    end
  end

  describe 'available_users' do
    render_views
    it 'renders a list of users that can be added to the project' do
      sign_in admin_user
      project.remove_user(user)
      get :available_users, params: { id: project.noid }
      expect(CGI.unescapeHTML(response.body)).to include(user.last_name.to_s)
    end
  end

  describe 'add_users' do
    it 'attaches one or more users to a project' do
      sign_in admin_user
      get :add_users, params: { id: project.noid, user_ids: [user.id] }
      expect(project.users).to include user
    end
  end

  describe 'remove_user' do
    it 'removes a user from a project' do
      sign_in admin_user
      project.attach_user(user)
      expect(project.users).to include user
      get :remove_user, params: { id: project.noid, user_id: user.id }
      expect(project.users).not_to include user
    end
  end

  describe 'create_user' do
    it 'creates a user and attaches them to a project' do
      sign_in FactoryBot.create(:admin)
      post :create_user, params: { id: project.noid, user: { email: 'test@email.com', first_name: 'Doug', last_name: 'Dimmadome' } }
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].to_s).to eq('test@email.com')
      expect(project.users).not_to be_empty
    end
  end

  describe 'show' do
    it 'renders the show partial if the user has access' do
      expect(project.public?).to be true
      get :show, params: { id: project.noid }
      expect(response).to render_template('projects/show')
    end
  end

  describe 'workflows' do
    it 'lists all workflows associated with this project' do
      sign_in admin_user # TODO: not a requirement but it should be
      get :workflows, params: { id: project.noid }
      expect(response).to render_template('projects/workflows')
    end
  end
end
