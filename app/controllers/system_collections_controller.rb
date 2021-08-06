# frozen_string_literal: true

class SystemCollectionsController < CatalogController
  def supplemental_uploads
    @project = Project.find(params[:id])
    @generic_upload = GenericUpload.new
  end

  def create_supplemental_file
    # Attach binary
    CreateBlobJob.perform_later(create_work.noid, create_generic_upload.id, create_file_set.noid)

    flash[:notice] = params.inspect
    redirect_to(collections_path(id: params[:system_collection]))
  end

  private

    def create_work
      @project = Project.find(params[:id])
      new_work = Work.new(title: params[:supplemental_file].original_filename,
                          project_id: @project.id,
                          a_member_of: params[:system_collection])
      metadata_adapter.persister.save(resource: new_work)
    end

    def create_file_set
      file_set = FileSet.new type: determine_classification(params[:supplemental_file].path)
      Valkyrie.config.metadata_adapter.persister.save(resource: file_set)
    end

    def create_generic_upload
      generic_upload = GenericUpload.new
      generic_upload.user = current_user
      generic_upload.binary.attach(params[:supplemental_file]) # Correct?
      generic_upload
    end
end
