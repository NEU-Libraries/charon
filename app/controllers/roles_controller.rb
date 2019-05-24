# frozen_string_literal: true

class RolesController < ApplicationController
  def new; end

  def create; end

  def edit
    @role = Role.find(params[:id])
    @user = @role.user
    @designation_list = Designation.all
  end

  def update; end

  def show; end
end
