# frozen_string_literal: true

class Project < Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :user_registry_id, Valkyrie::Types::Integer
end
