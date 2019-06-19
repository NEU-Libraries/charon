# frozen_string_literal: true

class SearchBuilder < Blacklight::AccessControls::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end

  self.default_processor_chain += [:exclude_unwanted_models]

  def exclude_unwanted_models(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "-internal_resource_tesim:\"SystemCollection\""
  end
end
