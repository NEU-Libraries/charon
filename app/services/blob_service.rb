# frozen_string_literal: true

class BlobService
  include MimeHelper

  def initialize(params)
    @upload = GenericUpload.find(params[:upload_id])
    @work = Work.find(params[:work_id])
    @file_set = FileSet.find(params[:file_set_id])
  rescue Valkyrie::Persistence::ObjectNotFoundError, ActiveRecord::RecordNotFound => e
    Rails.logger.error(e)
  end

  def run
    return if @upload.nil? || @work.nil? || @file_set.nil?
    return if @file_set.original_file? # idempotent step

    @file_set.member_ids += [create_blob.id]
    Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    CreateThumbnailJob.perform_later(@upload.id, @work.noid, @file_set.noid)
  end

  private

    def create_blob
      blob = Blob.new
      blob.file_identifier = create_file.id
      blob.original_filename = @upload.file_name
      blob.use = [Valkyrie::Vocab::PCDMUse.OriginalFile]
      saved_blob = Valkyrie.config.metadata_adapter.persister.save(resource: blob)
      LiberaJob.perform_later(@work.noid, saved_blob.noid) if determine_mime(saved_blob.file_path).subtype == 'pdf'
      saved_blob
    end

    def create_file
      Valkyrie.config.storage_adapter.upload(
        file: @upload.file,
        resource: @file_set,
        original_filename: @upload.file_name
      )
    end
end
