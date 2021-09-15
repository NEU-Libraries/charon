# frozen_string_literal: true

class Note < Resource
  attribute :region, Valkyrie::Types::String
  attribute :color, Valkyrie::Types::String
  attribute :leaflet_id, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)

  def comments
    # TODO: helper method to load all comments on a Note
  end
end
