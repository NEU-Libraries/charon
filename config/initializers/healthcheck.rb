# frozen_string_literal: true

Healthcheck.configure do |config|
  config.success = 200
  config.error = 503
  config.verbose = false
  config.route = '/healthcheck'
  config.method = :get

  # -- Checks --
  # Check if redis and sidekiq is available
  config.add_check :sidekiq, -> { !!Sidekiq.redis(&:info) rescue false }
  # Check if the db is available
  config.add_check :database, -> { ActiveRecord::Base.connection.execute('select 1') }
  # Check if the db is available and without pending migrations
  config.add_check :migrations,-> { ActiveRecord::Migration.check_pending! }
  # Check if the cache is available
  # config.add_check :cache, -> { Rails.cache.read('some_key') }
  # Check if the application required envs are defined
  # config.add_check :environments, -> { Dotenv.require_keys('ENV_NAME', 'ANOTHER_ENV') }
end
