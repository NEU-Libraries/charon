# frozen_string_literal: true

module MinervaHelper
  def minerva_work_id(auid)
    Minerva::Work.find_or_create_by(auid: auid).id
  end

  def minerva_user_id(auid)
    Minerva::User.find_or_create_by(auid: auid).id
  end

  def minerva_project_id(auid)
    Minerva::Project.find_or_create_by(auid: auid).id
  end
end
