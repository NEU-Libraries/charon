# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_check

  def index
    @users = User.all
  end

  def actions
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    @project = meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:project_id])
    @role = Role.find_by(user_id: current_user.id, user_registry_id: @project.user_registry_id)
  end

  def dashboard
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    # Find all projects whose user registries have current_user as a member
    project_ids = UserRegistry.joins(:roles).where(roles: { user_id: current_user.id }).pluck(:project_id)
    @projects = meta.query_service.find_many_by_ids(ids: project_ids)

    # skip project selection and send user to action list
    redirect_to action: 'actions', project_id: @projects.first.noid if @projects.count == 1
  end

  def user_check
    render_401 && return unless current_user
  end
end
