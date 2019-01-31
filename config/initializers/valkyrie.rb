# frozen_string_literal: true
require 'valkyrie'
Rails.application.config.to_prepare do
  Valkyrie::MetadataAdapter.register(
    Valkyrie::Persistence::Postgres::MetadataAdapter.new,
    :postgres
  )

  Valkyrie::MetadataAdapter.register(
    Valkyrie::Persistence::Memory::MetadataAdapter.new,
    :memory
  )

  Valkyrie::StorageAdapter.register(
    Valkyrie::Storage::Disk.new(base_path: Rails.root.join("tmp", "files")),
    :disk
  )

  Valkyrie::StorageAdapter.register(
    Valkyrie::Storage::Memory.new,
    :memory
  )

  Valkyrie::MetadataAdapter.register(
    Valkyrie::Persistence::Solr::MetadataAdapter.new(
        connection: Blacklight.default_index.connection,
        resource_indexer: Valkyrie::Persistence::Solr::CompositeIndexer.new(
            Valkyrie::Indexers::AccessControlsIndexer,
            ProjectIndexer,
            CollectionIndexer,
            WorkIndexer
        )
    ),
    :index_solr
  )

  Valkyrie::MetadataAdapter.register(
    Valkyrie::AdapterContainer.new(
      persister: Valkyrie::Persistence::CompositePersister.new(
        Valkyrie.config.metadata_adapter.persister,
        Valkyrie::MetadataAdapter.find(:index_solr).persister
      ),
      query_service: Valkyrie.config.metadata_adapter.query_service
    ),
    :composite_persister
  )
end
