# frozen_string_literal: true

class CreateThumbnailJob < ApplicationJob
  queue_as :default

  def perform(upload_id, work_id)
    file_set = FileSet.new type: 'generic'
    file_set = Valkyrie.config.metadata_adapter.persister.save(resource: file_set)

    # Simply run everything through. Will do Image/PDF check in the service
    ThumbnailService.new({ upload_id: upload_id,
                           work_id: work_id,
                           file_set_id: file_set.id }).create_thumbnail

    BlobService.new({ upload_id: upload_id,
                      file_set_id: file_set.id }).create_blob

    GenericUpload.find(upload_id).destroy!
  end
end
