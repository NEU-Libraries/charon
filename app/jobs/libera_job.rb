# frozen_string_literal: true

class LiberaJob < ApplicationJob
  queue_as :default

  def perform(work_id, blob_id)
    LiberaService.new({ work_id: work_id,
                        blob_id: blob_id }).run
  end
end
