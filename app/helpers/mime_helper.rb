# frozen_string_literal: true

require 'mimemagic/overlay'

module MimeHelper
  def determine_mime(file_path)
    mime = MimeMagic.by_magic(File.open(file_path))
    mime = MimeMagic.by_path(file_path) if mime.blank?
    return MimeMagic.new('application/octet-stream') if mime.blank?

    mime
  end

  def determine_classification(mime)
    # enumerate mime types to classification for file set type
  end
end
