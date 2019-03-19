# frozen_string_literal: true

class UsersController < ApplicationController

  before_action :user_check, only: :dashboard

  def index
    @users = User.all
  end

  def dashboard; end

  def user_check
    unless current_user
      render_401
    end
  end
end
