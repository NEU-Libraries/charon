# frozen_string_literal: true

class UserRegistry < ApplicationRecord
  has_many :roles
end
