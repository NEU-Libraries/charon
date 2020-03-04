# frozen_string_literal: true

class GenericUpload < ApplicationRecord
  has_one_attached :binary
  belongs_to :user

  def filename
    binary.blob.filename.to_s
  end

  def file
    File.open(file_path)
  end

  def file_path
    ActiveStorage::Blob.service.path_for(binary.key)
  end

  def project
    Project.find(project_id)
  end
end
