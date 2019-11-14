# frozen_string_literal: true

class WorksController < ApplicationController
  def new; end

  def create; end

  def edit; end

  def update; end

  def show
    @work = Work.find(params[:id])
  end

  def history
  end
end
