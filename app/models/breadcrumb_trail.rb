# frozen_string_literal: true

class BreadcrumbTrail < Croutons::BreadcrumbTrail
  def projects_users
    breadcrumb("Hats", "http://www.google.com")
    breadcrumb("Ducks", "http://www.google.com")
    breadcrumb("Google", "http://www.google.com")
  end
end
