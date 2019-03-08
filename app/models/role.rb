# frozen_string_literal: true

class Role < ApplicationRecord
  enumeration :designation
  belongs_to :user_registry
  belongs_to :user
end
