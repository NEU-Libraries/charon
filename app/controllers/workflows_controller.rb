# frozen_string_literal: true

class WorkflowsController < ApplicationController
  def new
    @project_id = Minerva::Project.find_or_create_by(auid: params[:project_id]).id
    @creator_id = Minerva::User.find_or_create_by(auid: current_user.id).id
    @workflow = Minerva::Workflow.new
    @tasks = Task.all
  end

  def create
    permitted = params.require(:workflow).permit(:title, :ordered, :task_list, :project_id, :creator_id)
    @workflow = Minerva::Workflow.create!(permitted)
    redirect_to workflow_path(@workflow)
  end

  def edit; end

  def update; end

  def show
    @workflow = Minerva::Workflow.find(params[:id])
    @project = Project.find(Minerva::Project.find(@workflow.project_id).auid)
  end
end
