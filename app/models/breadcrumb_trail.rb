# frozen_string_literal: true

class BreadcrumbTrail < Croutons::BreadcrumbTrail
  def projects_users
    breadcrumb(objects[:project].title, actions_path(objects[:project]))
    breadcrumb('User Registry')
  end

  def roles_edit
    breadcrumb(objects[:role].project.title, actions_path(objects[:role].project))
    breadcrumb('User Registry', project_users_path(objects[:role].project))
    breadcrumb(objects[:role].user.first_name + '\'s Role')
  end

  def projects_available_users
    breadcrumb(objects[:project].title, actions_path(objects[:project]))
    breadcrumb('User Registry', project_users_path(objects[:project]))
    breadcrumb('Available Users')
  end

  def shared_new_user
    if objects[:project].present?
      breadcrumb(objects[:project].title, actions_path(objects[:project]))
      breadcrumb('User Registry', project_users_path(objects[:project]))
    else # admin create
      breadcrumb('Admin Dashboard', admin_dashboard_path)
    end
    breadcrumb('New User')
  end

  def projects_new
    breadcrumb('Admin Dashboard', admin_dashboard_path)
    breadcrumb('New Project')
  end

  def collections_show
    breadcrumb(objects[:collection].parent.title, project_path(objects[:collection].parent))
    breadcrumb(objects[:collection].title)
  end

  def system_collections_show
    breadcrumb(objects[:system_collection].parent.title, project_path(objects[:system_collection].parent))
    breadcrumb(objects[:system_collection].title)
  end

  def workflows_new
    breadcrumb(objects[:project].title, actions_path(objects[:project]))
    breadcrumb('New Workflow')
  end

  def workflows_edit
    breadcrumb(objects[:project].title, actions_path(objects[:project]))
    breadcrumb(objects[:workflow].title)
  end

  def workflows_show
    breadcrumb(objects[:project].title, actions_path(objects[:project]))
    breadcrumb(objects[:workflow].title)
  end

  def projects_workflows
    breadcrumb(objects[:project].title, actions_path(objects[:project]))
    breadcrumb('Workflows')
  end

  def works_show
    breadcrumb(objects[:work].parent.parent.title, project_path(objects[:work].parent.parent))
    breadcrumb(objects[:work].parent.title, collection_path(objects[:work].parent))
    breadcrumb(objects[:work].title)
  end

  def works_history
    breadcrumb(objects[:work].parent.parent.title, project_path(objects[:work].parent.parent))
    breadcrumb(objects[:work].parent.title, collection_path(objects[:work].parent))
    breadcrumb(objects[:work].title, work_path(objects[:work]))
    breadcrumb('History')
  end
end
