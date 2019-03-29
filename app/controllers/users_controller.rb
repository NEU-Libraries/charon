# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_check, only: :dashboard

  def index
    @users = User.all
  end

  def tasks
    meta = Valkyrie::MetadataAdapter.find(:composite_persister)
    @project = meta.query_service.find_by_alternate_identifier(alternate_identifier: params[:project_id])
    @role = Role.find_by(user_id: current_user.id, user_registry_id: @project.user_registry_id)
  end

  def dashboard; end

  def user_check
    render_401 && return unless current_user
  end
end
