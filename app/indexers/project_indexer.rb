# frozen_string_literal: true

class ProjectIndexer
  delegate :query_service, to: :metadata_adapter
  attr_reader :resource
  def initialize(resource:)
    @resource = resource
  end

  def metadata_adapter
    Valkyrie.config.metadata_adapter
  end

  def to_solr
    {}
  end
end
