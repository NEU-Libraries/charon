# frozen_string_literal: true

class SystemCollectionsController < CatalogController
  include Searchable

  load_resource except: %i[new create edit update]
  before_action :searchable, only: [:show]

  helper_method :sort_column, :sort_direction

  # Blacklight incantations
  blacklight_config.track_search_session = false
  layout 'application'

  def new; end

  def create; end

  def edit; end

  def update; end

  def show
    @response, @document_list = search_service.fetch(
      metadata_adapter.query_service.find_inverse_references_by(
        resource: @system_collection, property: :a_member_of
      ).map(&:id).map(&:to_s).to_a
    )
  end
end
