# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    first_name { 'Doug' }
    last_name { 'Dimmadome' }
    password { 'password' }
  end
end
