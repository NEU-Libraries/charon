# frozen_string_literal: true

class CollectionChangeSet < Valkyrie::ChangeSet
  property :title
  property :a_member_of
  validates :title, presence: true
end
