# frozen_string_literal: true

class WorkflowsController < ApplicationController
  def new
    @workflow = Minerva::Workflow.new
    @tasks = Task.all
  end

  def create; end

  def edit; end

  def update; end

  def show; end
end
