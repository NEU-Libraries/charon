# frozen_string_literal: true

FactoryBot.define do
  factory :work do
    transient do
      project { FactoryBot.create_for_repository(:project) }
    end

    title { Faker::Company.name }
    a_member_of { project.incoming_collection.id }
    project_id { project.id }
    workflow_id { create(:workflow).id }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end

    trait :fake_thumbnail do
      thumbnail { true }
    end
  end
end
