# frozen_string_literal: true

class Role < ApplicationRecord
  enumeration :designation
  belongs_to :user_registry
  belongs_to :user

  def manager?
    user.admin? || (designation == :manager)
  end

  def editor?
    user.admin? || (designation == :manager) || (designation == :editor)
  end

  def creator?
    user.admin? || (designation == :manager) || (designation == :editor) || (designation == :creator)
  end

  def depositor?
    user.admin?                   ||
      (designation == :manager)   ||
      (designation == :editor)    ||
      (designation == :creator)   ||
      (designation == :depositor)
  end

  def project
    meta = Valkyrie.config.metadata_adapter
    meta.query_service.find_by(id: user_registry.project_id)
  end
end
