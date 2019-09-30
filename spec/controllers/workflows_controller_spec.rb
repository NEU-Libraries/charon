# frozen_string_literal: true

require 'rails_helper'

describe WorkflowsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:admin_user) { create(:admin) }
  let(:workflow) { create(:workflow) }

  describe 'new' do
    render_views
    it 'renders new workflow form' do
      sign_in admin_user
      get :new, params: { project_id: project.id }
      expect(CGI.unescapeHTML(response.body)).to include('Create Workflow')
    end
  end

  describe 'create' do
    it 'creates a workflow' do
      sign_in admin_user
      pid = Minerva::Project.find_or_create_by(auid: project.noid).id
      cid = Minerva::User.find_or_create_by(auid: admin_user.id).id
      post :create, params: { workflow: { project_id: pid, creator_id: cid, title: 'Test', ordered: true, task_list: "[\"Encode\",\"Catalog\",\"Review\",\"Transcribe\",\"Publish\"]" } }
      response.should redirect_to workflow_path(Workflow.last)
    end
  end

  describe 'show' do
    render_views
    it 'renders the show view' do
      get :show, params: { id: workflow.id }
      expect(CGI.unescapeHTML(response.body)).to include(workflow.title)
    end
  end

  describe 'edit' do
    render_views
    it 'renders and edit form' do
      sign_in admin_user
      get :edit, params: { id: workflow.id }
      expect(CGI.unescapeHTML(response.body)).to include(workflow.title)
    end
  end

  describe 'update' do
    it 'udpates a workflow' do
      sign_in admin_user
      pid = Minerva::Project.find_or_create_by(auid: project.noid).id
      cid = Minerva::User.find_or_create_by(auid: admin_user.id).id
      post :update, params: { id: workflow.id, workflow: { project_id: pid, creator_id: cid, title: 'Test', ordered: true, task_list: "[\"Encode\",\"Catalog\",\"Review\",\"Transcribe\",\"Publish\"]" } }
      response.should redirect_to workflow_path(workflow.id)
    end
  end
end
