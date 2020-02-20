# frozen_string_literal: true

require 'mimemagic/overlay'

module MimeHelper
  def determine_mime(file_path)
    mime = MimeMagic.by_magic(File.open(file_path))
    mime = MimeMagic.by_path(file_path) if mime.blank?
    mime
  end

  def epub?(magic_mime)
    magic_mime.subtype.include?('epub')
  end

  def image?(magic_mime)
    magic_mime.mediatype == 'image'
  end

  def pdf?(magic_mime)
    magic_mime.subtype == 'pdf'
  end

  def video?(magic_mime)
    magic_mime.mediatype == 'video'
  end

  def audio?(magic_mime)
    magic_mime.mediatype == 'audio'
  end

  def msword?(magic_mime); end

  def msexcel?(magic_mime); end

  def msppt?(magic_mime); end

  def text?(magic_mime)
    magic_mime.mediatype == 'text'
  end
end
