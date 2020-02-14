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

  def render_thumbnail(document, options)
    image_tag("https://repository.library.northeastern.edu/downloads/neu:m0453923d?datastream_id=thumbnail_4")
  end
end
