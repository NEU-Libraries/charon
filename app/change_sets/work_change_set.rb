class WorkChangeSet < Valkyrie::ChangeSet
  property :title
  property :a_member_of
  validates :title, presence: true
end