# frozen_string_literal: true

class CollectionsController < CatalogController
  include Searchable

  load_resource except: %i[new create edit update]
  before_action :searchable, only: [:show]

  # Blacklight incantations
  blacklight_config.track_search_session = false
  layout 'application'

  def new; end

  def create; end

  def edit; end

  def update; end

  def show
    @response, @document_list = search_service.fetch(
      @collection.filtered_children
    )
  end
end
