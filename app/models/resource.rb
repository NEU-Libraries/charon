# frozen_string_literal: true

class Resource < Valkyrie::Resource
  enable_optimistic_locking
  include Charon::Resource::AccessControls

  attribute :locked, Valkyrie::Types::Hash
  attribute :alternate_ids,
            Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true).default {
              [Valkyrie::ID.new(Minter.mint)]
            }

  def lock(user_id)
    self.locked = { user_id: user_id, time: DateTime.now, duration: 1.hour }
  end

  def unlock
    self.locked = nil
  end

  def locked?
    # if not nil, check time
    return DateTime.now < locked[:time] + locked[:duration] unless locked.nil?

    false
  end

  def noid
    alternate_ids.first.to_s
  end

  def to_param
    noid
  end

  def reload
    Resource.find(id)
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
    result = []
    result.concat Valkyrie.config.metadata_adapter.query_service.find_inverse_references_by(
      resource: self, property: :a_member_of
    ).to_a
    result.concat Valkyrie.config.metadata_adapter.query_service.find_members(resource: self).to_a
    result.uniq
  end

  def filtered_children
    children.select { |c| c.is_a?(SystemCollection) || is_a?(Collection) || is_a?(Work) }.map(&:id).map(&:to_s).to_a
  end
end
