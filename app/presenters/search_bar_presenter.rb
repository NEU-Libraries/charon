# frozen_string_literal: true

class SearchBarPresenter
  attr_reader :configuration, :view_context, :controller

  # Set the partial this presenter draws
  class_attribute :partial
  self.partial = 'catalog/search_form'

  def initialize(controller, configuration = view_context.blacklight_config)
    @controller = controller
    @view_context = controller.view_context
    @configuration = configuration
  end

  def render
    unless controller.is_a?(Blacklight::Catalog) && controller.action_name == 'index'
      return unless controller.instance_variable_get(:@searchable)
    end
    # :nocov:
    view_context.render partial, presenter: self
    # :nocov:
  end

  ##
  # @return [Boolean] should autocomplete be enabled in the UI
  def autocomplete_enabled?
    configuration.autocomplete_enabled.present? &&
      configuration.autocomplete_path.present?
  end

  ##
  # If no search parameters have been given, we should
  # auto-focus the user's cursor into the searchbox
  #
  # @return [Boolean]
  def autofocus?
    # controller.is_a?(Blacklight::Catalog) &&
    #   controller.action_name == "index" &&
    #   !controller.has_search_parameters?

    # Disabling
    false
  end
end
