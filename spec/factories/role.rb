# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    designation { Designation.user }
    user { create(:user) }
    user_registry { FactoryBot.create_for_repository(:project).user_registry }
  end
end
