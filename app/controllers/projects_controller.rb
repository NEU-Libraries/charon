# frozen_string_literal: true

class ProjectsController < ApplicationController
  def new
    @change_set = ProjectChangeSet.new(Project.new)
  end

  def create
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    change_set = ProjectChangeSet.new(Project.new)
    if change_set.validate(params[:project])
      change_set.sync
      @project = meta.persister.save(resource: change_set.resource)
    end
    redirect_to project_path(@project)
  end

  def edit; end

  def update; end

  def show; end
end
