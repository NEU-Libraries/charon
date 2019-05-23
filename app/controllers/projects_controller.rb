# frozen_string_literal: true

class ProjectsController < ApplicationController
  include UserCreatable
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

  def available_users
    # Need to filter down to users not already attached to project
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    @project = meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:project_id])
    already_attached_users = @project.users
    @users = User.all.select{|u| !already_attached_users.include? u}
  end

  def users
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    @project = meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:project_id])
    @roles = @project.roles.order(sort_column + ' ' + sort_direction)
  end

  def new_user
    @user = User.new
    @create_user_path = project_create_user_path
    render 'shared/new_user'
  end

  def create_user
    @user = manufacture_user(params)

    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    project = meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:project_id])

    project.attach_user(@user)

    UserMailer.with(user: @user).system_created_user_email.deliver_now
    flash[:notice] = "User successfully created. Email sent to #{@user.email} for notification."
    redirect_to actions_path(project.noid)
  end

  def sort_column
    return 'designation' unless params[:sort]

    (User.column_names + Role.column_names).include?(params[:sort].split('.').last) ? params[:sort] : 'designation'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
