# frozen_string_literal: true

class Work < Resource
  include ModsDisplay::ModelExtension

  attribute :title, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)
  attribute :workflow_id, Valkyrie::Types::Integer
  attribute :mods_xml, Valkyrie::Types::String.default { '<_/>' }

  mods_xml_source(&:mods_xml)

  def history
    Minerva::State.where(work_id: Minerva::Work.find_or_create_by(auid: noid).id)
  end

  def workflow
    Workflow.find(workflow_id)
  end
end
