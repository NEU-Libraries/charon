class ProjectsController < ApplicationController
  # layout "application"
  def new
    @project = Project.new
  end
end
