# frozen_string_literal: true

class WorkflowsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    pid = Minerva::Project.find_or_create_by(auid: params[:project_id]).id
    cid = Minerva::User.find_or_create_by(auid: current_user.id).id
    @workflow = Workflow.new(task_list: Task.all.map{ |t| t.name}, project_id: pid, creator_id: cid)
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
    permitted = params.require(:workflow).permit(:title, :ordered, :task_list, :project_id, :creator_id)
    @workflow.update_attributes! permitted
    flash[:notice] = "Successfully edited workflow."
    redirect_to workflow_path(@workflow)
  end

  def show
    @workflow = Workflow.find(params[:id])
    @project = @workflow.project
    @tasks = JSON.parse(@workflow.task_list)
  end
end
