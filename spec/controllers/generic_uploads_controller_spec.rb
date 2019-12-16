# frozen_string_literal: true

require 'rails_helper'

describe GenericUploadsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:generic_upload) { create(:generic_upload) }
  let(:workflow) { create(:workflow) }

  describe 'new' do
    it 'renders the new record form' do
      get :new
      expect(response).to render_template('generic_uploads/new')
    end
  end

  describe 'create' do
    context 'with valid input' do
      it 'creates a generic upload' do
        sign_in FactoryBot.create(:user)
        file = fixture_file_upload(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png')
        expect { post :create, params: { generic_upload: { binary: file, project_id: project.id } } }.to change(ActiveStorage::Attachment, :count).by(1)
      end
    end
  end

  describe 'approve' do
    it 'shows workflows for the project' do
      get :approve, params: { id: generic_upload.id }
      expect(response).to render_template('generic_uploads/approve')
      # TODO: actually test that the render lists specific workflows
    end
  end

  describe 'attach' do
    it 'associates a workflow with a new work made from an upload' do
      sign_in FactoryBot.create(:admin)
      get :attach, params: { id: generic_upload.id, workflow_id: workflow.id }
      created_work = Valkyrie.config.metadata_adapter.query_service.find_all_of_model(model: Work).last
      expect(response).to redirect_to(created_work)
      expect(created_work.workflow_id).to eq(workflow.id.to_s)
    end
  end

  describe 'reject' do
    it 'deletes on rejection' do
      to_be_deleted = create(:generic_upload)
      expect { post :reject, params: { id: to_be_deleted.id } }.to change(GenericUpload, :count).by(-1)
      # TODO: test that the user gets notified
    end
  end
end
