# frozen_string_literal: true

class ProjectsSearchBuilder < Blacklight::AccessControls::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  self.default_processor_chain -= [:exclude_unwanted_models]
end
