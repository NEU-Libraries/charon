# frozen_string_literal: true

class FileSetChangeSet < Valkyrie::ChangeSet
  property :title
  property :file_identifiers
  validates :title, presence: true
end
