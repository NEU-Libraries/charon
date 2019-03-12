# frozen_string_literal: true

class Collection < Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)
end
