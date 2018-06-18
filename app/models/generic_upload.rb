class GenericUpload < ApplicationRecord
  mount_uploaders :generics, GenericUploader
  serialize :avatars, JSON # If you use SQLite, add this line.
end
