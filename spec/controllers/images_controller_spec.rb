# frozen_string_literal: true

require 'rails_helper'

describe ImagesController do
  let(:stack) { FactoryBot.create_for_repository(:stack) }

  describe 'manifest' do
    it 'generates a IIIF manifest' do
      expect(stack.children.count).to eq(1)
      get :manifest, params: { id: stack.noid }
      # expect(JSON.parse(response.body)['sequences'][0]['canvases'][0]['label']).to eq('Image 1')
      # TODO - fix
    end
  end
end
