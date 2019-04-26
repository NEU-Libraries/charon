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
    # Find all user registries where current_user is a member
  end

  def user_check
    render_401 && return unless current_user
  end
end
