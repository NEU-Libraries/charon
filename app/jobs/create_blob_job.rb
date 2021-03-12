# frozen_string_literal: true

class CreateBlobJob < ApplicationJob
  queue_as :default

  def perform(resource_id, upload_id, file_set_id)
    BlobService.new({ resource_id: resource_id,
                      upload_id: upload_id,
                      file_set_id: file_set_id }).run
  end
end
