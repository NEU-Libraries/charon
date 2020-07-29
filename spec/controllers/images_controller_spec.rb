# frozen_string_literal: true

require 'rails_helper'

describe ImagesController do
  let(:file_set) { FactoryBot.create_for_repository(:file_set, :png) }

  describe 'manifest' do
    it 'generates a IIIF manifest' do
      get :manifest, params: { id: file_set.noid }
      expect(JSON.parse(response.body)['sequences'][0]['canvases'][0]['label']).to eq('Image 1')
    end
  end
end
