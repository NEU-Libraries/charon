# frozen_string_literal: true

class Ability
  include CanCan::Ability
  include Blacklight::AccessControls::Ability

  delegate :admin?, to: :current_user

  self.ability_logic += %i[
    base_permissions
    role_permissions
    admin_permissions
  ]

  def base_permissions
    can :read, :all, &:public?
  end

  def role_permissions
    can :oversee, Project do |p|
      current_user&.manager? p
    end
    can :editorialize, Project do |p|
      current_user&.editor? p
    end
    can :initiate, Project do |p|
      current_user&.creator? p
    end
    can :deposit, Project do |p|
      current_user&.depositor? p
    end
  end

  def admin_permissions
    can :manage, :all if current_user&.admin?
  end
end
