# frozen_string_literal: true

class Project < Resource
  include SystemCollectionGenerator
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :user_registry_id, Valkyrie::Types::Integer

  # TODO: Probably should change this signature so that 2nd param is a designation
  # for clarity and flexability
  def attach_user(user, manager = false)
    # check to see if user is already attached
    # in which case do nothing
    return if Role.where(user_registry_id: user_registry.id, user_id: user.id).exists?

    d = if manager
          Designation.manager
        else
          Designation.user
        end

    role = Role.new(user: user, user_registry: user_registry, designation: d)
    user_registry.roles << role
    user_registry.save!
  end

  def remove_user(user)
    return unless user.roles.where(user_registry_id: user_registry_id).exists?

    role = Role.where(user_registry_id: user_registry_id, user_id: user.id).take
    user_registry.roles.delete(role)
    role.destroy!
  end

  def user_registry
    UserRegistry.find(user_registry_id)
  end

  def roles
    user_registry.roles.includes(:user)
  end

  def users
    roles.map(&:user)
  end
end
