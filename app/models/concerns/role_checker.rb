# frozen_string_literal: true

module RoleChecker
  def developer?
    capacity == :developer
  end

  def admin?
    developer? || capacity == :administrator
  end

  def manager?(project)
    role_check(project, Designation.manager)
  end

  def editor?(project)
    return true if manager?(project)

    role_check(project, Designation.editor)
  end

  def creator?(project)
    return true if editor?(project)

    role_check(project, Designation.creator)
  end

  def depositor?(project)
    return true if creator?(project)

    role_check(project, Designation.depositor)
  end

  private

    def role_check(project, designation)
      return false if role(project).nil?
      return true if admin?
      return true if designation(project) == designation

      false
    end
end
