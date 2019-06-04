# frozen_string_literal: true

require 'database_cleaner'

namespace :reset do
  desc 'Clean solr and dbs'
  task clean: :environment do
    raise "Wrong env - #{Rails.env} - must be development" unless Rails.env.development? || Rails.env.staging?

    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean
    Blacklight.default_index.connection.delete_by_query '*:*'
  end

  desc 'Clean database and repopulate with sample data'
  task data: [:clean] do
    raise "Wrong env - #{Rails.env} - must be development" unless Rails.env.development? || Rails.env.staging?

    meta = Valkyrie.config.metadata_adapter

    u = User.create(password: 'password', email: 'test_admin@email.xyz', first_name: 'Test', last_name: 'Admin', capacity: Capacity.administrator)
    ur = UserRegistry.create
    p = Project.new(title: 'Test Project', description: 'Test test test', user_registry_id: ur.id)

    saved_p = meta.persister.save(resource: p)
    ur.project_id = saved_p.id
    ur.save!

    r = Role.create(user: u, user_registry: ur, designation: Designation.user)

    ur.roles << r

    # Add random users with faker
    9.times do
      u = User.create(password: Devise.friendly_token.first(10), email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
      ur.roles << Role.create(user: u, user_registry: ur, designation: Designation.all.sample)
    end

    # Add loose random users
    10.times do
      u = User.create(password: Devise.friendly_token.first(10), email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
    end

    ur.save!

    saved_p.generate_system_collections

    User.create(password: 'password', email: 'p.yott@northeastern.edu', first_name: 'Patrick', last_name: 'Yott', capacity: Capacity.administrator)
    User.create(password: 'password', email: 'p.murray-john@northeastern.edu', first_name: 'Patrick', last_name: 'Murray-John', capacity: Capacity.administrator)
    User.create(password: 'password', email: 'j.flanders@northeastern.edu', first_name: 'Julia', last_name: 'Flanders', capacity: Capacity.administrator)
    User.create(password: 'password', email: 'a.rust@northeastern.edu', first_name: 'Amanda', last_name: 'Rust', capacity: Capacity.administrator)
    User.create(password: 'password', email: 'sj.sweeney@northeastern.edu', first_name: 'Sarah', last_name: 'Sweeney', capacity: Capacity.administrator)
    User.create(password: 'password', email: 'm.barney@northeastern.edu', first_name: 'Megan', last_name: 'Barney', capacity: Capacity.administrator)
  end
end
