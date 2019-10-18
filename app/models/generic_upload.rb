# frozen_string_literal: true

class GenericUpload < ApplicationRecord
  has_one_attached :binary

  def filename
    binary.blob.filename.to_s
  end
end
