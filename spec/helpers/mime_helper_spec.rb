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
      base_path = Rails.root.join('spec/fixtures/files/example').to_s
      expect(helper.determine_classification(base_path + '.xlsx')).to eql(Classification.spreadsheet.name)
      expect(helper.determine_classification(base_path + '.pptx')).to eql(Classification.presentation.name)
      expect(helper.determine_classification(base_path + '.docx')).to eql(Classification.text.name)
    end
  end
end
