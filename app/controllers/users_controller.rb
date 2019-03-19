# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_check, only: :dashboard

  def index
    @users = User.all
  end

  def dashboard; end

  def user_check
    render_401 && return unless current_user
  end
end
