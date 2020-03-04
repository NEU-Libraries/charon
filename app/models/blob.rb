# frozen_string_literal: true

class Blob < Resource
  attribute :mime_type, Valkyrie::Types::Set
  attribute :original_filename, Valkyrie::Types::Set
  attribute :file_identifier, Valkyrie::Types::ID
  attribute :use, Valkyrie::Types::Set

  def thumbnail?
    use.include?(Valkyrie::Vocab::PCDMUse.ThumbnailImage)
  end
end
