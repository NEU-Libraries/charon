# frozen_string_literal: true

class ProjectChangeSet < Valkyrie::ChangeSet
  property :title
  property :description
  validates :title, presence: true
end
