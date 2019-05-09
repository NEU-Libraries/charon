# frozen_string_literal: true

require 'database_cleaner'

namespace :reset do
  desc 'Clean solr and dbs'
  task clean: :environment do
    raise "Wrong env - #{Rails.env} - must be development" unless Rails.env.development?

    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean
    Blacklight.default_index.connection.delete_by_query '*:*'
  end

  desc 'Clean database and repopulate with sample data'
  task data: [:clean] do
    raise "Wrong env - #{Rails.env} - must be development" unless Rails.env.development?

    meta = Valkyrie::MetadataAdapter.find(:composite_persister)

    u = User.create(password: 'password', email: 'test_admin@email.xyz', first_name: 'Test', last_name: 'Admin', capacity: Capacity.administrator)
    ur = UserRegistry.create
    p = Project.new(title: 'Test Project', description: 'Test test test', user_registry_id: ur.id)

    meta.persister.save(resource: p)

    r = Role.create(user: u, user_registry: ur, designation: Designation.user)

    ur.roles << r
    ur.save!

    p.generate_system_collections
  end
end
