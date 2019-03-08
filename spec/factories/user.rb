# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    first_name { 'Doug' }
    last_name { 'Dimmadome' }
    password { 'password' }

    factory :dev do
      capacity { Capacity.developer }
    end

    factory :admin do
      capacity { Capacity.administrator }
    end
  end
end
