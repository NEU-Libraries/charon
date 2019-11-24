# frozen_string_literal: true

class Work < Resource
  attribute :title, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)
  attribute :workflow_id, Valkyrie::Types::Integer
  attribute :mods, Valkyrie::Types::String
  attribute :mods_html, Valkyrie::Types::String
end
