# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    title { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    a_member_of { FactoryBot.create_for_repository(:project).id }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end
  end
end
