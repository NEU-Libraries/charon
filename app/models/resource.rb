# frozen_string_literal: true

class Resource < Valkyrie::Resource
  attribute :alternate_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true).default{[::Noid::Rails::Service.new.mint]}

  def to_param
    alternate_ids.first.to_s
  end
end
