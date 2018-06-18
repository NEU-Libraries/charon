class GenericUpload < ApplicationRecord
  mount_uploaders :generics, GenericUploader
  serialize :generics, JSON # If you use SQLite, add this line.
end
