# frozen_string_literal: true

class WorksController < ApplicationController
  include ModsDisplay::ControllerExtension

  def new; end

  def create; end

  def edit; end

  def update; end

  def show
    @work = Work.find(params[:id])
    # render_mods_display(@model).to_html
  end

  def history
  end
end
