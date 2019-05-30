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
end
