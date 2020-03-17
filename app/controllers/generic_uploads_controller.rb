# frozen_string_literal: true

class GenericUploadsController < ApplicationController
  load_resource except: %i[new create edit update]

  before_action :file_presence_check, only: [:create]
  after_action :make_upload_state, :make_approval_state, only: [:attach]

  def new
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit(:binary, :project_id))
    gu.user = current_user
    gu.save!

    flash[:notice] = "File #{gu.filename} uploaded"
    redirect_to(actions_path(params[:generic_upload][:project_id])) && return
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
    @saved_work = create_work(@generic_upload.filename,
                              @generic_upload.project.id,
                              @generic_upload.project.incoming_collection.id,
                              params[:workflow_id])

    # Notify user of acceptance
    @generic_upload.user.notify('Upload Approved',
                                "Your upload #{@generic_upload.filename} was approved")
    create_thumbnail
    @generic_upload.destroy!
    redirect_to(work_path(@saved_work))
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

    def file_presence_check
      file_presence_error if params[:generic_upload][:binary].blank?
    end

    def file_presence_error
      flash[:error] = 'File not selected for upload'
      redirect_to(root_path) && return
    end

    def create_work(title, project_id, parent_id, workflow_id)
      # Create a work and make it belong to incoming
      new_work = Work.new(title: title,
                          project_id: project_id,
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

    def create_thumbnail
      @file_set = FileSet.new type: 'generic'
      @file_set = metadata_adapter.persister.save(resource: @file_set)

      if determine_mime(@generic_upload.file).image?
        ThumbnailService.new({ upload_id: @generic_upload.id,
                               work_id: @saved_work.id,
                               file_set_id: @file_set.id }).create_thumbnail
      end

      BlobService.new({ upload_id: @generic_upload.id,
                        file_set_id: @file_set.id }).create_blob
    end
end
