# frozen_string_literal: true

class AdminController < ApplicationController
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
    @user = User.new(password:Devise.friendly_token[0,20], :email => params[:user][:email], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name])
    @user.save!
  end

  private

  def admin_check
    render_401 && return unless current_user
    render_403 && return unless current_user.admin?
  end
end
