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

  def self.find(id)
    # expect noid
    Valkyrie.config.metadata_adapter.query_service.find_by_alternate_identifier(alternate_identifier: id)
  rescue Valkyrie::Persistence::ObjectNotFoundError
    # try standard valkyrie
    Valkyrie.config.metadata_adapter.query_service.find_by(id: id)
  end

  def parent
    Valkyrie.config.metadata_adapter.query_service.find_references_by(resource: self, property: :a_member_of).first
  end

  def children
    Valkyrie.config.metadata_adapter.query_service.find_inverse_references_by(
      resource: self, property: :a_member_of
    )
  end
end
