# frozen_string_literal: true

class AdminController < ApplicationController
  include UserCreatable

  before_action :admin_check

  def new; end

  def create; end

  def edit; end

  def update; end

  def show; end

  def dashboard; end

  def new_user
    @user = User.new
    @create_user_path = admin_create_user_path
    render 'shared/new_user'
  end

  def create_user
    @user = manufacture_user(params)
    UserMailer.with(user: @user).system_created_user_email.deliver_now
    flash[:notice] = "User successfully created. Email sent to #{@user.email} for notification."
    redirect_to admin_dashboard_url
  end
end
