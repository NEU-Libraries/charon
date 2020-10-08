# frozen_string_literal: true

require 'rails_helper'

describe ImagesController do
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:blob) { FactoryBot.create_for_repository(:blob, :pdf) }
  let(:libera_service) { LiberaService.new({ work_id: work.id, blob_id: blob.id }) }

  describe 'manifest' do
    it 'generates a IIIF manifest' do
      expect { libera_service.run }.to change { work.children.count }.from(0).to(1)
      expect(work.children[0].class).to eq(Stack)

      stack = work.children[0]
      get :manifest, params: { id: stack.noid }
      expect(JSON.parse(response.body)['sequences'][0]['canvases'][0]['label']).to eq('Image 1')

      page = stack.children.select { |c| c.class == Page }.first
      get :single_manifest, params: { id: page.thumbnail }
      expect(JSON.parse(response.body)['sequences'][0]['canvases'][0]['label']).to eq('Image 1')
    end
  end
end
