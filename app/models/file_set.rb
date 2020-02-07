# frozen_string_literal: true

class FileSet < Resource
  attribute :title, Valkyrie::Types::String
  attribute :file_metadata, Valkyrie::Types::Set.of(FileMetadata.optional)
  attribute :a_member_of, Valkyrie::Types::ID
end
