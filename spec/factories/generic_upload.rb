# frozen_string_literal: true

FactoryBot.define do
  factory :generic_upload do
    user { create(:user) }
    binary { fixture_file_upload(Rails.root.join('public/apple-touch-icon.png'), 'image/png') }
    project_id { FactoryBot.create_for_repository(:project).noid }
  end
end
