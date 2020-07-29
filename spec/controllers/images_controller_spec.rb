# frozen_string_literal: true

require 'rails_helper'

describe ImagesController do
  let(:file_set) { FactoryBot.create_for_repository(:file_set, :png) }

  describe 'manifest' do
    it 'generates a IIIF manifest' do
      get :manifest, params: { id: file_set.noid }
      expect(CGI.unescapeHTML(response.body)).to eq('')
    end
  end
end
