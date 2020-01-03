# frozen_string_literal: true

class GenericUploadsController < ApplicationController
  load_resource except: %i[new create edit update]

  after_action :make_upload_state, :make_approval_state, only: [:attach]

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
    @workflows = Workflow.where(
      project_id: Minerva::Project.where(
        auid: @generic_upload.project_id
      ).take&.id
    )
  end

  def deny; end

  def attach
    Minerva::Interface.create(title: 'upload', code_point: 'generic_uploads#new')

    @saved_work = create_work(@generic_upload.filename,
                              @generic_upload.project.incoming_collection.id,
                              params[:workflow_id])

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

  private

    def create_work(title, parent_id, workflow_id)
      # Create a work and make it belong to incoming
      new_work = Work.new(title: title,
                          a_member_of: parent_id,
                          workflow_id: workflow_id)
      metadata_adapter.persister.save(resource: new_work)
    end

    def make_upload_state
      upload_state = Minerva::State.new(
        creator_id: minerva_user_id(@generic_upload.user.id),
        work_id: minerva_work_id(@saved_work.noid),
        interface_id: upload_interface.id,
        status: Status.complete.name
      )
      raise StandardError, state.errors.full_messages unless upload_state.save
    end

    def make_approval_state
      upload_approval_state = Minerva::State.new(
        creator_id: minerva_user_id(current_user.id),
        work_id: minerva_work_id(@saved_work.noid),
        status: Status.available.name
      )
      raise StandardError, state.errors.full_messages unless upload_approval_state.save
    end
end
