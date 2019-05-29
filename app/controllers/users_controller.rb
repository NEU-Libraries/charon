# frozen_string_literal: true

class UsersController < ApplicationController
  include UserCreatable

  before_action :user_check

  def index
    @users = User.all
  end

  def actions
    @project = find_resource
    @role = Role.find_by(user_id: current_user.id, user_registry_id: @project.user_registry_id)
  end

  def dashboard
    # TODO: if system administrator, return all projects - solve no roles condition
    # Find all projects whose user registries have current_user as a member
    project_ids = UserRegistry.joins(:roles).where(roles: { user_id: current_user.id }).pluck(:project_id)
    @projects = metadata_adapter.query_service.find_many_by_ids(ids: project_ids)

    # skip project selection and send user to action list
    redirect_to action: 'actions', id: @projects.first.noid if @projects.count == 1
  end

  def new_user
    @user = User.new
    @create_user_path = users_create_user_path
    render 'shared/new_user'
  end

  def create_user
    @user = manufacture_user(params)

    # Associate user with project
    project = find_resource
    project.attach_user(@user)

    UserMailer.with(user: @user).system_created_user_email.deliver_now
    flash[:notice] = "User successfully created. Email sent to #{@user.email} for notification."
    redirect_to users_dashboard_url
  end

  def user_check
    render_401 && return unless current_user
  end
end
