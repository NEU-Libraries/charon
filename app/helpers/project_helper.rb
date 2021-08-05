# frozen_string_literal: true

module ProjectHelper
  def create_project(project_values)
    project = nil
    user_registry = UserRegistry.create
    change_set = ProjectChangeSet.new(Project.new(user_registry_id: user_registry.id))
    if change_set.validate(project_values)
      change_set.sync
      project = metadata_adapter.persister.save(resource: change_set.resource)
    end

    generate_system_collections(project)
    project
  end

  def generate_system_collections(project)
    # After successfull creation of project, create system collections
    # and associate with the resource
    user_registry.project_id = project.id
    user_registry.save!
    project.generate_system_collections
  end
end
