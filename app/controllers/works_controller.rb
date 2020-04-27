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

  def tasks
    @work = Work.find(params[:id])
    @users = @work.project.users.sort_by(&:last_name).collect { |u| ["#{u.last_name}, #{u.first_name}", u.id] }
    # .unshift(['Select User', ''])
  end

  def assign_task
    work = Work.find(params[:id])
    user = User.find(params[:user][:id])
    task = Task.find(params[:task])

    save_state(current_user.id, user.id, work.noid, task)

    flash[:notice] = 'Task assigned'
    redirect_to(root_path)
  end

  private

    def save_state(current_user_id, user_id, work_noid, task_title)
      Minerva::State.create(
        creator_id: minerva_user_id(current_user_id),
        user_id: minerva_user_id(user_id),
        work_id: minerva_work_id(work_noid),
        interface_id: Minerva::Interface.find_by(title: task_title).id,
        status: Status.assigned.name
      )
    end
end
