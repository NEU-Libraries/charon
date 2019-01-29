class CollectionChangeSet < Valkyrie::ChangeSet
  property :title
  property :member_of_collection_id
  property :member_of_project_id
  validates :title, presence: true
end
