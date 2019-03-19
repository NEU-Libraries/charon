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
    render_401 && return unless current_user
    render_403 && return unless current_user.admin?
  end
end
