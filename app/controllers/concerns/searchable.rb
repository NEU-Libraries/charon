# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  def searchable
    @searchable = true
  end
end
