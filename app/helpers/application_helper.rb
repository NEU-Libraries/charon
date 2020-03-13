# frozen_string_literal: true

module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} #{sort_arrow(column, direction)}", sort: column, direction: direction
  end

  def sort_arrow(column, direction)
    return '▸' if column != sort_column
    return '▴' if direction == 'asc'

    '▾'
  end

  def application_version
    VERSION
  end

  def render_thumbnail(document, _options)
    # image_tag('https://repository.library.northeastern.edu/downloads/neu:m0451f929?datastream_id=thumbnail_4', size: '50x50')
    if document.thumbnail?
      # Need to pass in an array to account for 2x values
      @large_thumbnail_path   = "#{iiif_url}/2/#{document.id}.jp2/full/!400,400/0/default.jpg"
      @medium_thumbnail_path  = "#{iiif_url}/2/#{document.id}.jp2/full/!200,200/0/default.jpg"
      @small_thumbnail_path   = "#{iiif_url}/2/#{document.id}.jp2/full/!100,100/0/default.jpg"
      render 'shared/thumbnail'
    end
  end

  def iiif_url
    Rails.application.config.iiif['url']
  end
end
