# frozen_string_literal: true

class BlobService
  include MimeHelper
  include ValkyrieHelper

  def initialize(params)
    @upload = GenericUpload.find(params[:upload_id])
    @resource = Resource.find(params[:resource_id])
    @file_set = FileSet.find(params[:file_set_id])
  rescue Valkyrie::Persistence::ObjectNotFoundError, ActiveRecord::RecordNotFound => e
    Rails.logger.error(e)
  end

  def run
    return if @upload.nil? || @resource.nil? || @file_set.nil?
    return if @file_set.original_file? # idempotent step

    @blob = create_blob(create_file(@upload.file_path,
                                    @file_set, @upload.file_name).id,
                        @upload.file_name,
                        Valkyrie::Vocab::PCDMUse.OriginalFile)

    @file_set.member_ids += [@blob.id]

    Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    run_jobs
  end

  private

    def run_jobs
      CreateThumbnailJob.perform_later(@upload.id, @resource.noid, @file_set.noid)
      LiberaJob.perform_later(@resource.noid, @blob.noid) if determine_mime(@blob.file_path).split('/')[1] == 'pdf'
    end
end
