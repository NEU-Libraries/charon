# frozen_string_literal: true

class WorksController < ApplicationController
  include ModsDisplay::ControllerExtension

  def new; end

  def create; end

  def edit; end

  def update; end

  def show
    @work = Work.find(params[:id])
    @mods_html = render_mods_display(@work).to_html
  end

  def history
    @work = Work.find(params[:id])
  end

  def assign_task
    @work = Work.find(params[:id])
    @users = @work.project.users.collect {|u| [ "#{u.last_name}, #{u.first_name}", u.id ]}
  end

  def task_assignment
    # Pair work, user and task
  end
end
