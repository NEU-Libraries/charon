# frozen_string_literal: true

class WorkflowsController < ApplicationController
  def new
    # @project_id = params[:project_id]
    # @creator_id = params[:creator_id]
    @project_id = Minerva::Project.find_or_create_by(:auid => '3tx969p').id
    @creator_id = Minerva::User.find_or_create_by(:auid => '28').id
    @workflow = Minerva::Workflow.new
    @tasks = Task.all
  end

  def create
    # flash[:notice] = params[:workflow]["title"]
    # flash[:notice] = params[:workflow].inspect
    permitted = params.require(:workflow).permit(:title, :ordered, :task_list, :project_id, :creator_id)
    # flash[:notice] = (params.require(:workflow).permit(:title, :ordered, :task_list)).inspect
    @workflow = Minerva::Workflow.create!(permitted)
    # flash[:notice] = @workflow.inspect
    # redirect_to root_path
    redirect_to workflow_path(@workflow)
  end

  def edit; end

  def update; end

  def show; end
end
