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
        render :template => '/pages/401', :layout => "error", :formats => [:html], :status => 401 and return
      end
      unless current_user.admin?
        render :template => '/pages/403', :layout => "error", :formats => [:html], :status => 403
      end
    end
end
