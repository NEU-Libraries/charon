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
end
