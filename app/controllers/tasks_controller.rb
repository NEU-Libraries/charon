# frozen_string_literal: true

class TasksController < ApplicationController
  include ModsDisplay::ControllerExtension

  def catalog
    @work = Work.find(params[:id])
    @mods_html = render_mods_display(@work).to_html

    catalog_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(@work.noid),
      interface_id: catalog_interface.id,
      status: Status.in_progress.name
    )

    raise StandardError, state.errors.full_messages unless catalog_state.save
  end

  def update_work
    work = Work.find(params[:id])
    # raw xml param
    change_set = WorkChangeSet.new(work)
    if change_set.validate(params[:work])
      change_set.sync
      saved_work = metadata_adapter.persister.save(resource: change_set.resource)
    end

    flash[:notice] = "MODS updated for #{saved_work.title}"
    redirect_to root_url
  end

  def transcribe
    @work = Work.find(params[:id])
  end

  def encode
    @work = Work.find(params[:id])
  end

  def review
    @work = Work.find(params[:id])
  end

  def publish
    @work = Work.find(params[:id])
  end

  def claim
    @work = Work.find(params[:id])
    # get list of tasks from workflow
    # search work history for in progress and completed tasks
  end

  def assign
    # make task in progress
    # update minerva state
  end
end
