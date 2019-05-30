# frozen_string_literal: true

class UserRegistry < ApplicationRecord
  has_many :roles, dependent: :destroy
end
