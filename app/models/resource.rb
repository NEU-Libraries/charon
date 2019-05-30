# frozen_string_literal: true

class Resource < Valkyrie::Resource
  include Charon::Resource::AccessControls

  attribute :alternate_ids,
            Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true).default {
              [Valkyrie::ID.new(Minter.mint)]
            }

  def noid
    alternate_ids.first.to_s
  end

  def to_param
    noid
  end
end
