# frozen_string_literal: true

class GenericUploadsController < ApplicationController
  include StateHelper
  load_resource except: %i[new create edit update]

  before_action :file_presence_check, only: [:create]
  # after_action :make_upload_state, :make_approval_state, only: [:attach]

  def new
    @project = Project.find(params[:project_id])
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit(:binary, :project_id))
    gu.user = current_user
    gu.save!

    flash[:notice] = "File #{gu.file_name} uploaded"
    redirect_to(actions_path(params[:generic_upload][:project_id])) && return
  end

  def show; end

  def approve
    @project = Project.find(@generic_upload.project_id)
    @workflows = Workflow.where(
      project_id: Minerva::Project.where(
        auid: @generic_upload.project_id
      ).take&.id
    )
  end

  def deny; end

  def attach
    @saved_work = create_work(@generic_upload.file_name,
                              @generic_upload.project.id,
                              @generic_upload.project.incoming_collection.id,
                              params[:workflow_id])

    notify_of_attachment
    CreateBlobJob.perform_later(@saved_work.noid, @generic_upload.id, create_file_set(@generic_upload.file_path).noid)
    make_upload_state(@generic_upload, @saved_work)

    redirect_to(work_path(@saved_work))
  end

  def reject
    # notify user of denial reason
    @generic_upload.user.notify('Upload Denied',
                                "Your upload #{@generic_upload.file_name} was denied - #{params[:denial]}")
    # remove binary
    @generic_upload.destroy
    flash[:notice] = 'User notified of denial and upload removed'
    redirect_to(root_path)
  end

  private

    def notify_of_attachment
      # Notify user of acceptance
      @generic_upload.user.notify('Upload Approved',
                                  "Your upload
                                  #{helpers.link_to @generic_upload.file_name, @saved_work}
                                  was approved")
    end

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

    def create_file_set(file_path)
      file_set = FileSet.new type: determine_classification(file_path)
      Valkyrie.config.metadata_adapter.persister.save(resource: file_set)
    end
end
