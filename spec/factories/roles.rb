# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    user { create(:user) }
    user_registry { create(:user_registry) }
  end
end
