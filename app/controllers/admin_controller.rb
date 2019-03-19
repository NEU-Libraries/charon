# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :admin_check

  def new; end

  def create; end

  def edit; end

  def update; end

  def show; end

  def dashboard; end

  private

    def admin_check
      unless current_user
        render_401
      end
      unless current_user.admin?
        render_403
      end
    end
end
