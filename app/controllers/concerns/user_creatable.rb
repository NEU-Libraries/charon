# frozen_string_literal: true

module UserCreatable
  class UserError < StandardError; end
  extend ActiveSupport::Concern

  included do
    rescue_from UserError, with: :user_error
    before_action :oversee_check, only: %i[available_users add_users remove_user user_registry new_user]
  end

  def user_registry
    @roles = @project.roles.order("#{sort_column} #{sort_direction}")
  end

  def manufacture_user(params)
    user = User.create(password: Devise.friendly_token[0, 20],
                       email: params[:user][:email],
                       first_name: params[:user][:first_name],
                       last_name: params[:user][:last_name])

    raise UserError, user.errors.full_messages.join('. ') if user.errors.full_messages.any?

    user
  end

  def user_error(exception)
    (flash[:error] = "Error creating user - #{exception}"
     redirect_to(root_path) && return)
  end

  def new_user
    @user = User.new
    @create_user_path = project_create_user_path
    render 'shared/new_user'
  end

  def sign_up
    @user = User.new
    @create_user_path = project_create_user_path
    render 'shared/sign_up'
  end

  def create_user
    @user = manufacture_user(params)
    @project.attach_user(@user)
    UserMailer.with(user: @user).system_created_user_email.deliver_now
    flash[:notice] = "User successfully created and attached to #{@project.title}. "\
                     "Email sent to #{@user.email} for notification."
    redirect_to actions_path(@project)
  end

  def available_users
    # Need to filter down to users not already attached to project
    already_attached_users = @project.users
    @users = User.all.reject { |u| already_attached_users.include? u }
  end

  def add_users
    user_ids = params[:user_ids]
    user_ids.each do |id|
      @project.attach_user(User.find(id))
    end
    flash[:notice] = "Successfully added users to #{@project.title}."
    redirect_to project_user_registry_path(@project)
  end

  def remove_user
    user = User.find(params[:user_id])
    @project.remove_user(user)
    flash[:notice] = "Successfully removed #{user.first_name} #{user.last_name} from #{@project.title}."
    redirect_to project_user_registry_path(@project)
  end
end
