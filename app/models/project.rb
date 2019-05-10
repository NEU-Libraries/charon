# frozen_string_literal: true

class Project < Resource
  include SystemCollectionGenerator
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :user_registry_id, Valkyrie::Types::Integer

  def attach_user(user)
    role = Role.new(user: user, user_registry: user_registry)
    user_registry.roles << role
    user_registry.save!
  end

  def user_registry
    UserRegistry.find(user_registry_id)
  end
end
