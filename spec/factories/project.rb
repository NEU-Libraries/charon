# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Test Project' }
    description { 'Test test test' }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end

    after(:create) do |project, _evaluator|
      project.generate_system_collections

      user_registry = UserRegistry.create
      project.user_registry_id = user_registry.id
      user_registry.project_id = project.id
      user_registry.save!
    end
  end
end
