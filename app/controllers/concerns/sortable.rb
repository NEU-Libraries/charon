# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  def sort_column
    return 'last_name' unless params[:sort]

    (User.column_names + Role.column_names).include?(params[:sort].split('.').last) ? params[:sort] : 'last_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
