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
  end

  def create_user
    @user = manufacture_user(params)

    UserMailer.with(user: @user).admin_created_user_email.deliver_now
    flash[:notice] = "User successfully created. Email sent to #{@user.email} for notification."
    redirect_to admin_dashboard_url
  end

  private

  def admin_check
    render_401 && return unless current_user
    render_403 && return unless current_user.admin?
  end
end
