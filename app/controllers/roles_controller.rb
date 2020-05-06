# frozen_string_literal: true

class RolesController < ApplicationController
  def new; end

  def create; end

  def edit
    @role = Role.find(params[:id])
    @user = @role.user
    @designation_list = Designation.all
  end

  def update
    role = Role.find(params[:id])
    role.designation = Designation.find(params[:designation])
    role.save!
    flash[:notice] = "User role successfully changed to #{params[:designation]}."
    redirect_to project_user_registry_path(role.project)
  end

  def show; end
end
