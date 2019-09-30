# frozen_string_literal: true

require 'rails_helper'

describe WorkflowsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:admin_user) { create(:admin) }

  describe 'new' do
    render_views
    it 'renders new workflow form' do
      sign_in admin_user
      get :new, params: { project_id: project.id }
      expect(CGI.unescapeHTML(response.body)).to include('Create Workflow')
    end
  end
end
