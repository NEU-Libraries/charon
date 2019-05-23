# frozen_string_literal: true

module SystemCollectionGenerator
  def generate_system_collections
    system_collections = []
    SystemCollectionType.all.each do |sct|
      system_collections << SystemCollection.new(a_member_of: id, system_collection_type: sct.to_s, title: sct.name)
    end

    system_collections.each do |sc|
      Valkyrie.config.metadata_adapter.persister.save(resource: sc)
    end
  end
end
