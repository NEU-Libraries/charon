# frozen_string_literal: true

FactoryBot.define do
  factory :generic_upload do
    user { create(:user) }
    binary { fixture_file_upload(Rails.root.join('spec/fixtures/files/image.png'), 'image/png') }
    project_id { FactoryBot.create_for_repository(:project).noid }

    trait :pdf do
      binary { fixture_file_upload(Rails.root.join('spec/fixtures/files/example.pdf'), 'application/pdf') }
    end
  end
end
