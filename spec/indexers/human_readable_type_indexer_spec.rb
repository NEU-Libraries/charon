# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HumanReadableTypeIndexer do
  describe '.to_solr' do
    let(:work) { FactoryBot.create(:work) }

    it 'indexes the human readable type name for a scanned resource' do
      output = described_class.new(resource: work).to_solr

      expect(output[:human_readable_type_ssim]).to eq 'Work'
    end
  end
end
