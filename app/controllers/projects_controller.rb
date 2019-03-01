# frozen_string_literal: true

class ProjectsController < ApplicationController
  def new
    @change_set = ProjectChangeSet.new(Project.new)
  end

  def create; end

  def edit; end

  def update; end

  def show; end
end
