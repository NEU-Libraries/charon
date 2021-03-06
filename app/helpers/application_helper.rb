# frozen_string_literal: true

module ApplicationHelper
  def column_sort(column, title = nil, anchor = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} #{sort_arrow(column, direction)}", sort: column, direction: direction, anchor: anchor
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
    render partial: 'shared/thumbnail', locals: { document: document, iiif: iiif_url }
  end

  def iiif_url
    Rails.application.config.iiif['url']
  end
end
