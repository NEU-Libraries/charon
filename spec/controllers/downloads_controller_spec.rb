# frozen_string_literal: true

require 'rails_helper'

describe DownloadsController do
  let(:blob) { FactoryBot.create_for_repository(:blob, :pdf) }

  describe 'download' do
    it 'uses send_file to download a Blob binary' do
      get :download, params: { id: blob.noid }
      expect(response.media_type).to eq 'application/pdf'
    end
  end
end
