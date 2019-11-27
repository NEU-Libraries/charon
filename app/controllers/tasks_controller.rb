# frozen_string_literal: true

class TasksController < ApplicationController
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
