# frozen_string_literal: true

class Note < Resource
  attribute :region, Valkyrie::Types::String
  attribute :color, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)

  def comments
    children.select { |c| c.instance_of?(Comment) }
  end

  def to_partial_path
    'notes/note'
  end
end
