# frozen_string_literal: true

module MimeHelper
  def determine_mime(file_path)
    mime = Marcel::MimeType.for(File.open(file_path))
    mime = Marcel::MimeType.for(Pathname.new(file_path)) if mime.blank?
    return 'application/octet-stream' if mime.blank?

    mime
  end

  def determine_classification(file_path)
    mime_array = determine_mime(file_path).split('/')
    subtype = mime_array[1]
    mediatype = mime_array[0]
    return Classification.text.name if subtype == 'pdf'

    extension = File.extname(file_path).delete!('.')
    result = by_extension(extension) if subtype.start_with?('vnd')
    result = Classification.find(mediatype) if result.nil?
    result.nil? ? Classification.work.name : result.name
  end

  private

    def by_extension(extension)
      case extension
      when 'docx', 'doc'
        Classification.text
      when 'xls', 'xlsx', 'xlw'
        Classification.spreadsheet
      when 'ppt', 'pptx', 'pps', 'ppsx'
        Classification.presentation
      end
    end
end
