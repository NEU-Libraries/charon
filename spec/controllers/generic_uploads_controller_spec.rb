# frozen_string_literal: true

require 'rails_helper'

describe GenericUploadsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:generic_upload) { create(:generic_upload) }

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
  end

  describe 'reject' do
    it 'deletes on rejection' do
      to_be_deleted = create(:generic_upload)
      expect { post :reject, params: { id: to_be_deleted.id } }.to change(GenericUpload, :count).by(-1)
      # TODO: test that the user gets notified
    end
  end
end
