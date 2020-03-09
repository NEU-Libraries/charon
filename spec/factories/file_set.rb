# frozen_string_literal: true

FactoryBot.define do
  factory :file_set do
    member_ids { FactoryBot.create_for_repository(:blob).id }
    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end
  end
end
