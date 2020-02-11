# frozen_string_literal: true

require 'mimemagic/overlay'

module MimeHelper
  def determine_mime(file_path)
    mime = MimeMagic.by_magic(File.open(file_path))
    if mime.blank?
      mime = MimeMagic.by_path(file_path)
    end
    return mime
  end

  def is_epub?(magic_mime)
    return magic_mime.subtype.include?("epub")
  end

  def is_image?(magic_mime)
    return magic_mime.mediatype == 'image'
  end

  def is_pdf?(magic_mime)
    return magic_mime.subtype == 'pdf'
  end

  def is_video?(magic_mime)
    return magic_mime.mediatype == 'video'
  end

  def is_audio?(magic_mime)
    return magic_mime.mediatype == 'audio'
  end

  def is_msword?(magic_mime)
  end

  def is_msexcel?(magic_mime)
  end

  def is_msppt?(magic_mime)
  end

  def is_text?(magic_mime)
    return magic_mime.mediatype == 'text'
  end
end
