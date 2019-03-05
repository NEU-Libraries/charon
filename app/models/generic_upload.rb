# frozen_string_literal: true

class GenericUpload < ApplicationRecord
  has_one_attached :binary
end
