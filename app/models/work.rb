# frozen_string_literal: true
# Generated with `rails generate valkyrie:model Work`
class Work < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls

  def current_state
    return Minerva::State.where(:work_id => self.id.to_s).last
  end
end
