# frozen_string_literal: true

class TasksController < ApplicationController
  include ModsDisplay::ControllerExtension

  def catalog
    @work = Work.find(params[:id])
    @mods_html = render_mods_display(@work).to_html

    wid = Minerva::Work.find_or_create_by(auid: @work.noid).id
    cid = Minerva::User.find_or_create_by(auid: current_user.id).id
    catalog_state = Minerva::State.new(creator_id: cid, work_id: wid, interface_id: catalog_interface.id, status: Status.in_progress.name)
    raise StandardError, state.errors.full_messages unless catalog_state.save
  end

  def update_work
    # work = Work.find(params[:id])
    # # raw xml param
    # change_set = WorkChangeSet.new(work)
    # if change_set.validate(params[:work])
    #   change_set.sync
    #   work = metadata_adapter.persister.save(resource: change_set.resource)
    # end

    work = Work.find(params[:id])
    work.mods_xml = params[:raw_xml]

    begin
      mods_title = Nokogiri::XML(work.mods_xml).at_xpath("//mods:titleInfo/mods:title").text
      if !mods_title.blank?
        work.title = mods_title
      end
    rescue Exception
      # TODO cleanup
    end

    saved_work = metadata_adapter.persister.save(resource: work)

    wid = Minerva::Work.find_or_create_by(auid: saved_work.noid).id
    cid = Minerva::User.find_or_create_by(auid: current_user.id).id
    catalog_state = Minerva::State.new(creator_id: cid, work_id: wid, interface_id: catalog_interface.id, status: Status.complete.name)
    raise StandardError, state.errors.full_messages unless catalog_state.save

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
