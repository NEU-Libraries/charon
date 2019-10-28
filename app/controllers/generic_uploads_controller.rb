# frozen_string_literal: true

class GenericUploadsController < ApplicationController
  def new
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit(:binary, :project_id))
    gu.save!

    redirect_to action: 'index'
  end

  def index
    @uploads = GenericUpload.all
  end

  def show; end

  def approve
    # get project and list workflows for attachment
    @generic_upload = GenericUpload.find(params[:id])
    @workflows = Workflow.where(project_id: Minerva::Project.where(auid: @generic_upload.project_id).take&.id)
  end

  def deny
  end

  def attach
    generic_upload = GenericUpload.find(params[:id])
    project = Project.find(generic_upload.project_id)
    # Create a work and make it belong to incoming
    new_work = Work.new(title: generic_upload.filename, a_member_of: project.incoming_collection.id)
    Valkyrie.config.metadata_adapter.persister.save(resource: new_work)
    redirect_to work_path(new_work) and return
    # Make a minerva state with status of available
    # Notify user of acceptance
  end

  def reject
    # find user
    # remove binary
    GenericUpload.find(params[:id]).destroy
    # notify user of denial reason
    # params[:denial]
  end
end
