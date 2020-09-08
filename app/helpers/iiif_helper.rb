# frozen_string_literal: true

module IiifHelper
  def universal_viewer_base_url
    "#{request&.base_url}/uv/uv.html"
  end

  def universal_viewer_config_url
    "#{request&.base_url}/uv/uv-config.json"
  end
end
