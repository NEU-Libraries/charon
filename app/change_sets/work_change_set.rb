class WorkChangeSet < Valkyrie::ChangeSet
  property :title
  property :member_of_collections_id
  validates :title, presence: true
end
