# frozen_string_literal: true

class SystemCollectionsController < ApplicationController
  load_resource except: %i[new create edit update]

  def new; end

  def create; end

  def edit; end

  def update; end

  def show; end
end
