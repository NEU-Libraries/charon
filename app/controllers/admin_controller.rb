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
      unless current_or_guest_user.admin?
        render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end
    end
end
