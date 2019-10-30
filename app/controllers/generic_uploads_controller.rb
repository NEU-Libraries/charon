# frozen_string_literal: true

class GenericUploadsController < ApplicationController
  def new
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit(:binary, :project_id))
    gu.user = current_user
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
    new_work = Work.new(title: generic_upload.filename, a_member_of: project.incoming_collection.id, workflow_id: params[:workflow_id])
    Valkyrie.config.metadata_adapter.persister.save(resource: new_work)
    # Make a minerva state with status of available
    # Notify user of acceptance
    generic_upload.user.notify("Upload Approved", "Your upload #{generic_upload.filename} was approved")
    redirect_to work_path(new_work) and return
  end

  def reject
    generic_upload = GenericUpload.find(params[:id])
    # notify user of denial reason
    generic_upload.user.notify("Upload Denied", "Your upload #{generic_upload.filename} was denied - #{params[:denial]}")
    # remove binary
    generic_upload.destroy
    flash[:notice] = "User notified of denial and upload removed"
    redirect_to(root_path) && return
  end
end
