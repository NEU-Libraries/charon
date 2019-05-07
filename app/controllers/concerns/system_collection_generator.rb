# frozen_string_literal: true

module SystemCollectionGenerator
  def generate_system_collections(project_id)
    system_collections = []
    SystemCollectionType.all.each do |sct|
      type = sct.to_s
      system_collections << SystemCollection.new(a_member_of: project_id, system_collection_type: type, title: type)
    end

    meta = Valkyrie::MetadataAdapter.find(:composite_persister)

    system_collections.each do |sc|
      meta.persister.save(resource: sc)
    end
  end
end
