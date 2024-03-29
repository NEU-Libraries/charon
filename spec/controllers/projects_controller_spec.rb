# frozen_string_literal: true

require 'rails_helper'

describe ProjectsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin) }

  describe 'users' do
    render_views
    it 'renders a list of users associated with the project' do
      Minerva::User.find_or_create_by(auid: user.id)
      project.attach_user(user, Designation.manager)
      sign_in admin_user
      get :users, params: { id: project.noid }
      expect(response).to render_template('projects/users')
      # TODO: actually look up their last action and check them
    end
  end

  describe 'works' do
    render_views
    it 'renders a list of works associated with the project' do
      sign_in admin_user
      get :works, params: { id: project.noid }
      expect(response).to render_template('projects/works')
      # TODO: have some dummy works and expect them be seen via title
    end
  end

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

      it 'creates a project with a manager' do
        sign_in admin_user
        post :create, params: { project: { title: 'Cat', description: 'In the hat', manager: user.id } }
        expect(assigns(:project).users.length).to eq(1) # Also test role TODO
      end
    end
  end

  describe 'user_registry' do
    render_views
    it 'lists the user registry for a given project' do
      project.attach_user(user, Designation.manager)
      expect(Ability.new(user).can?(:oversee, project)).to eq(true)
      sign_in user
      get :user_registry, params: { id: project.noid }
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
      get :user_registry, params: { id: project.noid, sort: 'users.last_name' }
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
    render_views
    it 'lists all workflows associated with this project' do
      sign_in admin_user # TODO: not a requirement but it should be
      get :workflows, params: { id: project.noid }
      expect(response).to render_template('projects/workflows')
    end
  end

  describe 'uploads' do
    render_views
    it 'lists the binary uploads that are associated with this project' do
      sign_in admin_user
      get :uploads, params: { id: project.noid }
      expect(response).to render_template('projects/uploads')
      # TODO: upload a file and check that it is in list
      # TODO: when none uploaded, check that partial indicates none
    end
  end

  describe 'update' do
    it 'modifies a project' do
      sign_in admin_user
      file = fixture_file_upload(Rails.root.join('public/apple-touch-icon.png'), 'image/png')
      post :update, params: { id: project.noid, project: { title: 'Duck', description: 'Goes quack!', binary: file } }
      expect(assigns(:project).title).to eq('Duck')
    end
  end

  describe 'sign_up' do
    it 'uses project affiliated path' do # need to serach for this in partial TODO
      get :sign_up, params: { id: project.noid }
      expect(response).to render_template('shared/sign_up')
    end
  end
end
