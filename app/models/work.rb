# frozen_string_literal: true

class Work < Resource
  include ModsDisplay::ModelExtension

  attribute :title, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)
  attribute :workflow_id, Valkyrie::Types::Integer
  attribute :project_id, Valkyrie::Types::ID
  attribute :mods_xml, Valkyrie::Types::String.default { '<_/>' }
  attribute :thumbnail, Valkyrie::Types::Bool

  mods_xml_source(&:mods_xml)

  def history
    State.where(work_id: Minerva::Work.find_or_create_by(auid: noid).id).order(:created_at).reverse_order
  end

  def workflow
    Workflow.find(workflow_id)
  end

  def project
    Project.find(project_id)
  end

  def state
    history&.first&.status
  end

  def responsible_user
    return User.find(Minerva::User.find(history.first.user_id).auid) if history&.first&.user_id.present?
  end

  def files
    children.map(&:files).flatten
  end

  def file_paths
    files.map(&:file_path)
  end
end
