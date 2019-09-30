# frozen_string_literal: true

class Workflow < Minerva::Workflow
  def project
    Project.find(Minerva::Project.find(project_id).auid)
  end
end
