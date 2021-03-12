# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  def sort_column
    return 'designation' unless params[:sort]

    (User.column_names + Role.column_names).include?(params[:sort].split('.').last) ? params[:sort] : 'designation'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
