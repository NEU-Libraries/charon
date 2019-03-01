# frozen_string_literal: true

# Generated with `rails generate valkyrie:model Project`
class Project < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :user_ids, Valkyrie::Types::Array
end
