# frozen_string_literal: true

class Project < Resource
  include SystemCollectionGenerator
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :user_registry_id, Valkyrie::Types::Integer

  def attach_user(user, manager = false)
    d = if manager
          Designation.manager
        else
          Designation.user
        end

    role = Role.new(user: user, user_registry: user_registry, designation: d)
    user_registry.roles << role
    user_registry.save!
  end

  def user_registry
    UserRegistry.find(user_registry_id)
  end

  def users
    user_registry.roles.map(&:user)
  end
end
