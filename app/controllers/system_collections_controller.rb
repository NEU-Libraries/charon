# frozen_string_literal: true

class SystemCollectionsController < ApplicationController
  include Searchable

  load_resource except: %i[new create edit update]
  before_action :searchable, only: [:show]

  def new; end

  def create; end

  def edit; end

  def update; end

  def show; end
end
