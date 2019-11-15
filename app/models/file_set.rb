# frozen_string_literal: true

class FileSet < Resource
  attribute :title, Valkyrie::Types::String
  attribute :file_identifiers, Valkyrie::Types::Set
  attribute :a_member_of, Valkyrie::Types::ID
end
