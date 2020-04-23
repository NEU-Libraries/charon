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
    # Pair work, user and task

    work = Work.find(params[:id])
    user = User.find(params[:user][:id])
    # task = Task.find(params[:task][:name].downcase)
    # interface_id ? need to correlate these

    state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      user_id: minerva_user_id(user.id),
      work_id: minerva_work_id(work.noid),
      status: Status.assigned.name
    )

    state.save

    flash[:notice] = state.inspect
    redirect_to(root_path)
  end
end
