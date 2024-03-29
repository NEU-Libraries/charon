# frozen_string_literal: true

class Project < Resource
  include SystemCollectionGenerator
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :user_registry_id, Valkyrie::Types::Integer
  attribute :thumbnail, Valkyrie::Types::ID

  # Minerva crossover
  def marked_for_destruction?
    false
  end

  def attach_user(user, designation = Designation.user)
    # check to see if user is already attached
    # in which case do nothing
    return if Role.exists?(user_registry_id: user_registry.id, user_id: user.id)

    role = Role.new(user: user, user_registry: user_registry, designation: designation)
    user_registry.roles << role
    user_registry.save!
  end

  def remove_user(user)
    return unless user.roles.exists?(user_registry_id: user_registry_id)

    role = Role.find_by(user_registry_id: user_registry_id, user_id: user.id)
    user_registry.roles.delete(role)
    role.destroy!
  end

  def user_registry
    UserRegistry.find_by(id: user_registry_id)
  end

  def roles
    user_registry&.roles&.includes(:user)
  end

  def users
    User.where(id: roles.select(:user_id))
  end

  def manager
    roles.find_by(designation: 'manager').user
  end

  def incoming_collection
    children.find { |c| c.system_collection_type == 'incoming' }
  end

  def works_collection
    children.find { |c| c.system_collection_type == 'works' }
  end

  def system_collections
    children.select { |c| c.is_a?(SystemCollection) }
  end

  def supplemental_collections
    system_collections.delete_if { |c| c.system_collection_type == 'works' || c.system_collection_type == 'incoming' }
  end

  def workflows
    Workflow.where(project_id: Minerva::Project.find_by(auid: noid)&.id)
  end

  def works
    Valkyrie.config.metadata_adapter.query_service.find_inverse_references_by(resource: self, property: :project_id)
  end
end
