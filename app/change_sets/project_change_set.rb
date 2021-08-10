# frozen_string_literal: true

class ProjectChangeSet < Valkyrie::ChangeSet
  property :title
  property :description
  property :manager, virtual: true
  validates :title, presence: true

  def manager=(manager_id)
    resource.attach_user(User.find(manager_id), Designation.manager)
  end
end
