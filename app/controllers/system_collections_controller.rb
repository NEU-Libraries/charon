# frozen_string_literal: true

class ProjectsController < CatalogController
  def create_supplemental_file
    # Attach binary
    CreateBlobJob.perform_later(create_work.noid, create_generic_upload.id, create_file_set.noid)

    flash[:notice] = params.inspect
    redirect_to(collections_path(id: params[:system_collection]))
  end

  private

    def create_work
      new_work = Work.new(title: params[:supplemental_file].original_filename,
                          project_id: @project.id,
                          a_member_of: params[:system_collection])
      metadata_adapter.persister.save(resource: new_work)
    end

    def create_fileset
      file_set = FileSet.new type: determine_classification(file_path)
      Valkyrie.config.metadata_adapter.persister.save(resource: file_set)
    end

    def create_generic_upload
      generic_upload = GenericUpload.new
      generic_upload.user = current_user
      generic_upload.binary.attach(params[:supplemental_file]) # Correct?
      generic_upload
    end
end
