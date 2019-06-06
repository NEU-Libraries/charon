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
      breadcrumb('New User')
    else # admin create
      breadcrumb('Admin Dashboard', admin_dashboard_path)
      breadcrumb('New User')
    end
  end

  def projects_new
    breadcrumb('Admin Dashboard', admin_dashboard_path)
    breadcrumb('New Project')
  end
end
