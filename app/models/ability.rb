# frozen_string_literal: true

class Ability
  include CanCan::Ability
  include Blacklight::AccessControls::Ability

  delegate :admin?, to: :current_user

  self.ability_logic += %i[
    base_permissions
    admin_permissions
  ]

  def base_permissions
    can :read, :all, &:public?
  end

  def admin_permissions
    can :manage, :all if current_user&.admin?
  end
end
