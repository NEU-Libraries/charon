# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    # Blacklight incantations
    blacklight_config.track_search_session = false
    layout 'application'
  end

  def searchable
    @searchable = true
  end
end
