# frozen_string_literal: true

require 'rails_helper'

describe ProjectsController do
  let(:project) { FactoryBot.create_for_repository(:project) }

  describe 'new' do
    it 'renders the new record form' do
      get :new
      expect(response).to render_template('projects/new')
    end
  end

  describe 'create' do
    context 'with valid input' do
      it 'creates a project' do
        post :create, params: { project: { title: 'Cat', description: 'In the hat' } }
        expect(assigns(:project).title).to eq('Cat')
      end
    end
  end

  describe 'users' do
    render_views
    it 'lists attached users for a given project' do
      get :users, params: { id: project.noid }
      expect(response.body).to include("User Registry for #{project.title}")
      # TODO: need to flesh this out by actually populating and looking for users
    end
  end

  describe 'new_user' do
    it 'renders the new user form' do
      get :new_user, params: { id: project.noid }
      expect(response).to render_template('shared/new_user')
    end
  end

  describe 'sort_column' do
    render_views
    it 'returns designation unless there is a value for params[:sort]' do
      get :users, params: { id: project.noid, sort: 'users.last_name' }
      expect(response.body).to include("Last Name ▾")
    end
  end

  describe 'available_users' do
    it 'renders a list of users that can be added to the project' do

    end
  end

  describe 'add_users' do
    it 'attaches one or more users to a project' do

    end
  end

  describe 'create_user' do
    it 'creates a user and attaches them to a project' do

    end
  end
end
