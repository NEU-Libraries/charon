# frozen_string_literal: true

class WorkflowsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_workflow

  def new
    @project = Project.find(params[:project_id])
    @workflow = Workflow.new(
      task_list: Task.all.map(&:name),
      project_id: minerva_project_id(params[:project_id]),
      creator_id: minerva_user_id(current_user.id)
    )
  end

  def create
    permitted = params.require(:workflow).permit(:title, :ordered, :task_list, :project_id, :creator_id)
    @workflow = Workflow.create!(permitted)
    redirect_to workflow_path(@workflow)
  end

  def edit
    @workflow = Workflow.find(params[:id])
    @project = @workflow.project
  end

  def update
    @workflow = Workflow.find(params[:id])
    permitted = update_param_filter(params)
    @workflow.update! permitted
    flash[:notice] = 'Successfully edited workflow.'
    redirect_to workflow_path(@workflow)
  end

  def show
    @workflow = Workflow.find(params[:id])
    @project = @workflow.project
    @tasks = JSON.parse(@workflow.task_list)
  end

  private

    def invalid_workflow(exception)
      flash[:error] = "Invalid workflow - #{exception}"
      redirect_to(root_path) && return
    end

    def update_param_filter(params)
      params
        .except(:project_id, :creator_id)
        .require(:workflow)
        .permit(:title, :ordered, :task_list, :project_id, :creator_id)
    end
end
