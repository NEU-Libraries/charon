# frozen_string_literal: true

FactoryBot.define do
  factory :blob do
    file_identifier { 'disk://' + Rails.root.join('spec/fixtures/files/image.png').to_s }
    original_filename { 'image.png' }
    to_create do |instance|
      Valkyrie.config.metadata_adapter.persister.save(resource: instance)
    end
  end
end
