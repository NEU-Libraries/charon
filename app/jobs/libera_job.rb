# frozen_string_literal: true

class LiberaJob < ApplicationJob
  queue_as :default

  def perform; end
end
