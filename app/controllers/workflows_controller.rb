# frozen_string_literal: true

class WorkflowsController < ApplicationController

  load_resource except: %i[new create edit update]
  before_action :searchable, only: [:show]

  def new
    @workflow = Minerva::Workflow.new
  end

  def create; end

  def edit; end

  def update; end

  def show; end

  def assign
    # TODO
  end

  def claim
    # TODO
  end
end
