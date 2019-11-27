# frozen_string_literal: true

class WorkChangeSet < Valkyrie::ChangeSet
  property :title
  property :a_member_of
  property :mods_xml
  validates :title, presence: true
end
