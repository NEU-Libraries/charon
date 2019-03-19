# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  include Blacklight::Controller
  layout :determine_layout

  def render_401
    render :template => '/pages/401', :layout => "error", :formats => [:html], :status => 401 and return
  end

  def render_403
    render :template => '/pages/403', :layout => "error", :formats => [:html], :status => 403 and return
  end
end
