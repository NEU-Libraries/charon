# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    designation { Designation.user }
  end
end
