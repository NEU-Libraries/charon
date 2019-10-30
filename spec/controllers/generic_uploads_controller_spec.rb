# frozen_string_literal: true

require 'rails_helper'

describe GenericUploadsController do
  let(:project) { FactoryBot.create_for_repository(:project) }

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
end
