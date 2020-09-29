# frozen_string_literal: true

class CatalogController < ApplicationController
  include Blacklight::Catalog
  include Blacklight::AccessControls::Catalog
  layout :determine_layout if respond_to? :layout

  # Apply the blacklight-access_controls
  # Skipping for now - not using BL to show anything (/projects/:noid e.g.)
  # before_action :enforce_show_permissions, only: :show

  # Devise does not control index (i.e. search) requests. Search results are limited to a user's access rights
  # via Blacklight::AccessControls::SearchBuilder.
  skip_authorize_resource only: :index

  self.search_service_class = ::SearchService

  # include Blacklight::DefaultComponentConfiguration

  self.search_state_class = SearchState

  configure_blacklight do |config|
    config.add_nav_action(:inbox, partial: 'mailboxer/nav/inbox')
    config.add_nav_action(:notifications, partial: 'mailboxer/nav/notifications')

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.index.partials = %i[index_header thumbnail index]
    config.view.gallery.partials = %i[index_header thumbnail index]

    # config.view.gallery.partials = %i[index_header thumbnail index]
    # config.view.masonry.partials = [:index]
    # config.view.slideshow.partials = [:index]

    config.index.thumbnail_method = :render_thumbnail

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.autocomplete_enabled = false
    config.index.search_bar_presenter_class = SearchBarPresenter
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::CatalogSearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fq: ['-internal_resource_tesim:SystemCollection',
           '-internal_resource_tesim:FileSet',
           '-internal_resource_tesim:Blob',
           '-internal_resource_tesim:Stack',
           '-internal_resource_tesim:Page']
    }

    # solr field configuration for search results/index views
    config.index.title_field = 'title_tesim'
    # config.index.display_type_field = 'has_model_ssim'
    config.index.display_type_field = 'human_readable_type_ssim'
    config.show.display_type_field = 'human_readable_type_ssim'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'All Fields'

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    # config.add_search_field('title') do |field|
    #   # :solr_local_parameters will be sent using Solr LocalParams
    #   # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    #   # Solr parameter de-referencing like $title_qf.
    #   # See: http://wiki.apache.org/solr/LocalParams
    #   field.solr_local_parameters = {
    #     qf: '$title_qf',
    #     pf: '$title_pf'
    #   }
    # end

    # config.add_search_field('author') do |field|
    #   field.solr_local_parameters = {
    #     qf: '$author_qf',
    #     pf: '$author_pf'
    #   }
    # end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    # config.add_search_field('subject') do |field|
    #   field.qt = 'search'
    #   field.solr_local_parameters = {
    #     qf: '$subject_qf',
    #     pf: '$subject_pf'
    #   }
    # end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_dtsi desc, title_tesi asc', label: 'relevance'
    config.add_sort_field 'pub_date_dtsi desc, title_tesi asc', label: 'year'
    config.add_sort_field 'author_tesi asc, title_tesi asc', label: 'author'
    config.add_sort_field 'title_tesi asc, pub_date_dtsi desc', label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # description_tesim
    config.add_index_field 'description_tesim', label: 'Description'
  end

  private

    # @note Overrides search service initialization to pass in current_ability.
    # We should be able to remove this once Blacklight access controls supports version 7.
    def search_service
      search_service_class.new(
        config: blacklight_config,
        user_params: search_state.to_h,
        current_ability: current_ability
      )
    end
end
