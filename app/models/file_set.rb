# frozen_string_literal: true
# Generated with `rails generate valkyrie:model FileSet`
class FileSet < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :file_identifiers, Valkyrie::Types::Set
end
