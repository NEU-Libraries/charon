# frozen_string_literal: true

class Blob < Resource
  attribute :mime_type, Valkyrie::Types::Set
  attribute :original_filename, Valkyrie::Types::Set
  attribute :file_identifier, Valkyrie::Types::ID
  attribute :use, Valkyrie::Types::Set

  def file_path
    file_identifier.id.split('disk://')[1]
  end
end
