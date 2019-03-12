# frozen_string_literal: true

class FileSet < Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :file_identifiers, Valkyrie::Types::Set
end
