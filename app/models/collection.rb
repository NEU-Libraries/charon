# frozen_string_literal: true
# Generated with `rails generate valkyrie:model Collection`
class Collection < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :member_of_collection_id, Valkyrie::Types::ID
  attribute :member_of_project_id, Valkyrie::Types::ID
end
