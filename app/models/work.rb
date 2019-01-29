# frozen_string_literal: true
# Generated with `rails generate valkyrie:model Work`
class Work < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls

  attribute :title, Valkyrie::Types::String
  attribute :a_member_of, Valkyrie::Types::Set.of(Valkyrie::Types::ID).meta(ordered: true)

  def current_state
    return Minerva::State.where(:work_id => self.id.to_s).last
  end
end
