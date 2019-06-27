# frozen_string_literal: true

module ApplicationHelper
  # kludge so we can keep Minerva as an isolated namespace but still use Blacklight layout
  def method_missing(method, *args, &block)
    if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  # :nocov:
  def respond_to_missing?(method_name, *args)
    if (method_name.to_s.end_with?('_path') ||
      method_name.to_s.end_with?('_url')) &&
       main_app.respond_to?(method_name)
      true
    else
      super
    end
  end
  # :nocov:

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
