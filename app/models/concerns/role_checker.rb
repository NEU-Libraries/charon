# frozen_string_literal: true

module RoleChecker
  def dev?
    capacity == :developer
  end

  def admin?
    dev? || capacity == :administrator
  end

  def manager?(project)
    role_check(project, Designation.manager)
  end

  def editor?(project)
    role_check(project, Designation.editor)
  end

  def creator?(project)
    role_check(project, Designation.creator)
  end

  def depositor?(project)
    role_check(project, Designation.depositor)
  end

  private

    def role_check(project, designation)
      return false if role(project).nil?
      return true if admin?
      return true if role(project).designation == designation

      false
    end
end
