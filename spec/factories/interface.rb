# frozen_string_literal: true

FactoryBot.define do
  factory :interface do
    title      { 'upload' }
    code_point { 'generic_uploads#new' }
  end
end
