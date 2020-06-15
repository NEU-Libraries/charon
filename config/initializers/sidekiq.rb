# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.set :sessions, false
Redis.exists_returns_integer = true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://redis:6379/0') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://redis:6379/0') }
end
