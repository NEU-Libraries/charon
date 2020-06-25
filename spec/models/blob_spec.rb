# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Blob do
  let(:resource_klass) { described_class }
  let(:blob) { FactoryBot.create_for_repository(:blob) }
  it_behaves_like 'a Valkyrie::Resource'

  describe '#file_path' do
    it 'returns the storage location of the blob' do
      expect(blob.file_path).to eq(Rails.root.join('spec/fixtures/files/image.png').to_s)
    end
  end
end
