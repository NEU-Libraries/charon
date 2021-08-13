# frozen_string_literal: true

class UsersController < ApplicationController
  include UserCreatable
  include ThumbnailHelper

  before_action :user_check

  def show
    @user = User.find(params[:id])
    @assignments = State.where(user_id: minerva_user_id(params[:id]))
    @user_actions = State.where(creator_id: minerva_user_id(params[:id]))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(params[:user].permit(:binary, :first_name, :last_name))
    @user.save!

    redirect_to user_path(@user)
  end

  def actions
    @project = find_resource
    @manager = current_user.manager?(@project)

    # TODO: - flash an error if the below isn't true. A redirect to the same page without
    # causes confusion
    redirect_to users_dashboard_url if !current_user.admin? && current_user.role(@project).nil?
  end

  def dashboard
    if current_user.admin?
      @projects = metadata_adapter.query_service.find_all_of_model(model: Project)
    else
      # Find all projects whose user registries have current_user as a member
      project_ids = UserRegistry.joins(:roles).where(roles: { user_id: current_user.id }).pluck(:project_id)
      @projects = metadata_adapter.query_service.find_many_by_ids(ids: project_ids)
    end

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

  def upload; end

  def create_users
    # CSV Mass Ingestion
    csv = CSV.parse params[:csv].read
    flash[:notice] = "#{csv.count} users successfully created."
    csv.each do |row|
      # ["lacy@franecki.net", "Tiara", "Hand"]
      User.create(password: Devise.friendly_token.first(10),
                  email: row[0],
                  first_name: row[1],
                  last_name: row[2])
    end

    redirect_to admin_dashboard_url
  end
end
