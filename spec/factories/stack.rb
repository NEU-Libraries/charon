# frozen_string_literal: true

FactoryBot.define do
  factory :stack do
    member_ids { FactoryBot.create_for_repository(:file_set, :pdf).id }

    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end
  end
end
