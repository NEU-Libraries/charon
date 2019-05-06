# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Test Project' }
    description { 'Test test test' }
    user_registry_id { create(:user_registry).id }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end

    after(:create) do |project, _evaluator|
      user_registry = UserRegistry.find(project.user_registry_id)
      user_registry.project_id = project.id
      user_registry.save!
    end
  end
end
