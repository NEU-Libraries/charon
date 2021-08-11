# frozen_string_literal: true

require 'rails_helper'

describe SystemCollectionsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:admin_user) { create(:admin) }

  describe 'supplemental_uploads' do
    it 'shows the upload form' do
      get :supplemental_uploads, params: { id: project.noid }
      expect(response).to render_template('system_collections/supplemental_uploads')
    end
  end

  describe 'create_supplemental_file' do
    it 'attaches the binary to a work that is created in the appropiate system collection' do
      sign_in admin_user
      file = fixture_file_upload(Rails.root.join('public/apple-touch-icon.png'), 'image/png')
      system_collection_id = project.supplemental_collections.first.id
      post :create_supplemental_file, params: { id: project.noid,
                                                supplemental_file: file,
                                                system_collection: system_collection_id }
      expect(SystemCollection.find(system_collection_id).children.length).to eq(1)
    end
  end
end
