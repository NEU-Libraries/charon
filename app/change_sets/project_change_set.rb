# frozen_string_literal: true

class ProjectChangeSet < Valkyrie::ChangeSet
  property :title
  property :description
  property :user_registry_id
  validates :title, presence: true
end
