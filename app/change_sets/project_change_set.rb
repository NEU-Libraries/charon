class ProjectChangeSet < Valkyrie::ChangeSet
  property :title
  validates :title, presence: true
end
