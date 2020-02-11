# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper

  include Blacklight::Controller
  include Croutons::Controller
  include InterfacesHelper
  include MinervaHelper
  include MimeHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Best to ask for breadcrumbs everywhere
  # and just avoid Croutons NotImplementedError
  def breadcrumbs
    super
  rescue NoMethodError, NotImplementedError
    # Just don't show them
    logger.info('No breadcrumbs found') && (return)
  end

  def render_401
    render template: '/pages/401', layout: 'error', formats: [:html], status: :unauthorized
  end

  def render_403
    render template: '/pages/403', layout: 'error', formats: [:html], status: :forbidden
  end

  def find_resource
    # expects id to be in params, and to be a noid
    meta = Valkyrie.config.metadata_adapter
    meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:id])
  end

  def metadata_adapter
    Valkyrie.config.metadata_adapter
  end

  # def storage_adapter
  #   Valkyrie.config.storage_adapter
  # end

  def admin_check
    render_401 && return unless current_user
    render_403 && return unless current_user.admin?
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    end
end
