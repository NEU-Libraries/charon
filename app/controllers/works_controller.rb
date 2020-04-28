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
  end

  def assign_task
    save_state
    flash[:notice] = 'Task assigned to user'
    redirect_to(project_works_path(Work.find(params[:id]).project))
  end

  private

    def save_state
      Minerva::State.create(
        creator_id: minerva_user_id(current_user.id),
        user_id: minerva_user_id(params[:user][:id]),
        work_id: minerva_work_id(params[:id]),
        interface_id: Minerva::Interface.find_by(title: params[:task]).id,
        status: Status.assigned.name
      )
    end
end
