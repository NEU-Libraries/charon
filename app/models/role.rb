# frozen_string_literal: true

class Role < ApplicationRecord
  enumeration :designation
  belongs_to :user_registry
  belongs_to :user

  def project
    meta = Valkyrie.config.metadata_adapter
    meta.query_service.find_by(id: user_registry.project_id)
  end
end
