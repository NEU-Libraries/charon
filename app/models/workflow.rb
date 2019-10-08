# frozen_string_literal: true

class Workflow < Minerva::Workflow
  validates :title, presence: true
  validates :task_list, presence: true

  def project
    Project.find(Minerva::Project.find(project_id).auid)
  end
end
