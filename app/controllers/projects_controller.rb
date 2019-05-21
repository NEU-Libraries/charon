# frozen_string_literal: true

class ProjectsController < ApplicationController
  helper_method :sort_column, :sort_direction

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

    # After successfull creation of project, create system collections
    # and associate with the resource

    @project.generate_system_collections

    redirect_to project_path(@project)
  end

  def edit; end

  def update; end

  def show; end

  def users
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    @project = meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:project_id])
    @roles = @project.roles.order(sort_column + ' ' + sort_direction)
  end

  def sort_column
    return 'designation' unless params[:sort]
    (User.column_names + Role.column_names).include?(params[:sort].split('.').last) ? params[:sort] : 'designation'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
