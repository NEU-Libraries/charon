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
end
