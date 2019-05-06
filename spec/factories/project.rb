# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Test Project' }
    description { 'Test test test' }
    user_registry_id { create(:user_registry).id }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end
  end
end
