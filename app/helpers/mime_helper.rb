# frozen_string_literal: true

require 'mimemagic/overlay'

module MimeHelper
  def determine_mime(file_path)
    mime = MimeMagic.by_magic(File.open(file_path))
    mime = MimeMagic.by_path(file_path) if mime.blank?
    return MimeMagic.new('application/octet-stream') if mime.blank?

    mime
  end

  def determine_classification(file_path)
    mime = determine_mime(file_path)
    return Classification.text.name if mime.subtype == 'pdf'

    extension = File.extname(file_path).delete!('.')
    result = by_extension(extension) if mime.subtype.start_with?('vnd')
    result = Classification.find(mime.mediatype) if result.nil?
    result.nil? ? Classification.work.name : result.name
  end

  private

    def by_extension(extension)
      case extension
      when (%w[docx doc].include? extension)
        Classification.text
      when (%w[xls xlsx xlw].include? extension)
        Classification.spreadsheet
      when (%w[ppt pptx pps ppsx].include? extension)
        Classification.presentation
      end
    end
end
