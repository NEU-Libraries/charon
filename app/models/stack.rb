# frozen_string_literal: true

class Stack < Resource
  attribute :type, Valkyrie::Types::String
  attribute :member_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)
  attribute :a_member_of, Valkyrie::Types::ID
  attribute :tei, Valkyrie::Types::String

  def pages
    children.select { |c| c.instance_of?(Page) }
  end
end
