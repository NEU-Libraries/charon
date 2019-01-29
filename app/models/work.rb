# frozen_string_literal: true
# Generated with `rails generate valkyrie:model Work`
class Work < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls

  attribute :title, Valkyrie::Types::String
  attribute :member_of_collections_id, Valkyrie::Types::Array

  def current_state
    return Minerva::State.where(:work_id => self.id.to_s).last
  end
end
