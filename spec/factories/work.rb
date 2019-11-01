# frozen_string_literal: true

FactoryBot.define do
  factory :work do
    title { Faker::Company.name }
    a_member_of { FactoryBot.create_for_repository(:project).incoming_collection.id }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end
  end
end
