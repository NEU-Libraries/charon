# frozen_string_literal: true

class WorksController < ApplicationController
  include ModsDisplay::ControllerExtension

  load_resource except: %i[new create edit update]

  def new; end

  def create; end

  def edit; end

  def update; end

  def show
    @mods_html = render_mods_display(@work).to_html
  end

  def history; end

  def tasks
    @users = @work.project.users.sort_by(&:last_name).collect { |u| ["#{u.last_name}, #{u.first_name}", u.id] }
  end

  def assign_task
    save_state
    flash[:notice] = 'Task assigned to user'
    redirect_to(project_works_path(@work.project))
  end

  private

    def save_state
      @task = Interface.find_by(title: params[:task])
      Minerva::State.create(
        creator_id: minerva_user_id(current_user.id),
        user_id: minerva_user_id(params[:user][:id]),
        work_id: minerva_work_id(params[:id]),
        interface_id: @task.id,
        status: Status.assigned.name
      )
      notify_user
    end

    def notify_user
      User.find(params[:user][:id]).notify('Task Assigned',
                                           "#{current_user.to_s} has tasked you with #{@task.present_tense} for #{@work.title}")
    end
end
