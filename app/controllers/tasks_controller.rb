# frozen_string_literal: true

class TasksController < ApplicationController
  include ModsDisplay::ControllerExtension

  def xml_editor
    @work = Work.find(params[:id])
    @mods_html = render_mods_display(@work).to_html
  end

  def catalog
    work = Work.find(params[:id])
    # raw xml param
    change_set = WorkChangeSet.new(work)
    if change_set.validate(params[:work])
      change_set.sync
      work = metadata_adapter.persister.save(resource: change_set.resource)
    end
  end
end
