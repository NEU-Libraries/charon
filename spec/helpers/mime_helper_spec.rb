# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MimeHelper, type: :helper do
  describe '#determine_mime' do
    it 'returns a MimeMagic object' do
      file_path = Rails.root.join('spec/fixtures/files/example.pdf').to_s
      expect(helper.determine_mime(file_path).subtype).to eql 'pdf'
    end
  end

  describe '#determine_classification' do
    it 'returns an appropiate enumeration for a file set' do
      file_path = Rails.root.join('spec/fixtures/files/example.xlsx').to_s
      expect(helper.determine_classification(file_path)).to eql(Classification.spreadsheet.name)
    end
  end
end
