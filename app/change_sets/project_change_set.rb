# frozen_string_literal: true

class ProjectChangeSet < Valkyrie::ChangeSet
  property :title
  property :description
  property :user_ids
  validates :title, presence: true
end
