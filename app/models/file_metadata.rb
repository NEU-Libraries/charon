# frozen_string_literal: true

class FileMetadata < Valkyrie::Resource
  attribute :mime_type, Valkyrie::Types::Set
  attribute :original_filename, Valkyrie::Types::Set
  attribute :file_identifiers, Valkyrie::Types::Set
  attribute :use, Valkyrie::Types::Set
end
