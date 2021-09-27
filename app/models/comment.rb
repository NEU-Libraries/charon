# frozen_string_literal: true

class Comment < Resource
  attribute :user_id, Valkyrie::Types::String
  attribute :message, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)

  def to_partial_path
    "comments/comment"
  end
end
