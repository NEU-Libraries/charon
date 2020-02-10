# frozen_string_literal: true

class FileSet < Resource
  attribute :type, Valkyrie::Types::String
  attribute :member_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID)
  attribute :a_member_of, Valkyrie::Types::ID

  def files
    @files ||= member_ids.map { |id| Blob.find(id) }
  end
end
