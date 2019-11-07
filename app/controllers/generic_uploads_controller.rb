# frozen_string_literal: true

class GenericUploadsController < ApplicationController
  load_resource except: %i[new create edit update]

  def new
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit(:binary, :project_id))
    gu.user = current_user
    gu.save!

    flash[:notice] = "File #{gu.filename} uploaded"
    redirect_to actions_path(params[:generic_upload][:project_id])
  end

  def show; end

  def approve
    @workflows = Workflow.where(project_id: Minerva::Project.where(auid: @generic_upload.project_id).take&.id)
  end

  def deny; end

  def attach
    # Create a work and make it belong to incoming
    new_work = Work.new(title: @generic_upload.filename,
                        a_member_of: @generic_upload.project.incoming_collection.id,
                        workflow_id: params[:workflow_id])
    saved_work = Valkyrie.config.metadata_adapter.persister.save(resource: new_work)
    # Make a minerva state with status of available
    wid = Minerva::Work.find_or_create_by(auid: saved_work.noid).id
    cid = Minerva::User.find_or_create_by(auid: current_user.id).id
    state = Minerva::State.new(creator_id: cid, work_id: wid, status: Status.available.name)
    raise StandardError, state.errors.full_messages unless state.save

    # Notify user of acceptance
    @generic_upload.user.notify('Upload Approved',
                                "Your upload #{@generic_upload.filename} was approved")
    @generic_upload.destroy!
    redirect_to(work_path(new_work))
  end

  def reject
    # notify user of denial reason
    @generic_upload.user.notify('Upload Denied',
                                "Your upload #{@generic_upload.filename} was denied - #{params[:denial]}")
    # remove binary
    @generic_upload.destroy
    flash[:notice] = 'User notified of denial and upload removed'
    redirect_to(root_path)
  end
end
