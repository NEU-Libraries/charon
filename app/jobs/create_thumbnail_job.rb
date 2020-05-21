# frozen_string_literal: true

class CreateThumbnailJob < ApplicationJob
  queue_as :default

  def perform(work_id)
    # Do something later
  end
end
