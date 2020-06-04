# frozen_string_literal: true

class CreateBlobJob < ApplicationJob
  queue_as :default

  def perform(upload_id, file_set_id)
    BlobService.new({ upload_id: upload_id,
                      file_set_id: file_set_id }).run
  end
end
