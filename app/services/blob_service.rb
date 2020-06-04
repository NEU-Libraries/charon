# frozen_string_literal: true

class BlobService
  def initialize(params)
    @upload = GenericUpload.find(params[:upload_id])
    @file_set = FileSet.find(params[:file_set_id])
  end

  def run
    blob = Blob.new
    blob.file_identifier = create_file.id
    blob.use = [Valkyrie::Vocab::PCDMUse.OriginalFile]
    saved_blob = Valkyrie.config.metadata_adapter.persister.save(resource: blob)
    @file_set.member_ids += [saved_blob.id]
    Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    CreateThumbnailJob.perform_later(@generic_upload.id, @saved_work.noid, fs.id)
  end

  private

    def create_file
      Valkyrie.config.storage_adapter.upload(
        file: @upload.file,
        resource: @file_set,
        original_filename: @upload.filename
      )
    end
end
