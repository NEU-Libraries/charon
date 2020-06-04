# frozen_string_literal: true

class CreateBlobJob < ApplicationJob
  queue_as :default

  def perform(work_id, upload_id, file_set_id)
    BlobService.new({ work_id: work_id,
                      upload_id: upload_id,
                      file_set_id: file_set_id }).run
  end
end
