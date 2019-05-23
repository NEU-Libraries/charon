# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  include Blacklight::Controller
  layout :determine_layout

  def render_401
    render template: '/pages/401', layout: 'error', formats: [:html], status: 401
  end

  def render_403
    render template: '/pages/403', layout: 'error', formats: [:html], status: 403
  end

  def find_resource
    # expects id to be in params, and to be a noid
    meta = Valkyrie.config.metadata_adapter
    meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:id])
  end

  def metadata_adapter
    Valkyrie.config.metadata_adapter
  end
end
