# frozen_string_literal: true

class CreateThumbnailJob < ApplicationJob
  queue_as :default

  def perform(upload_id, work_id, file_set_id)
    # Simply run everything through. Will do Image/PDF check in the service
    ThumbnailService.new({ upload_id: upload_id,
                           work_id: work_id,
                           file_set_id: file_set_id }).run
  end
end
