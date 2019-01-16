class GenericUpload < ApplicationRecord
  mount_uploaders :generics, GenericUploader
  serialize :generics, JSON
end
