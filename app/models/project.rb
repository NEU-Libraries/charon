# frozen_string_literal: true
# Generated with `rails generate valkyrie:model Project`
class Project < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  attribute :title, Valkyrie::Types::String
end
