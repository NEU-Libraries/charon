# frozen_string_literal: true

source 'https://rubygems.org'

gem 'blacklight'
gem 'blacklight-access_controls', git: 'https://github.com/projectblacklight/blacklight-access_controls.git'
gem 'blacklight-gallery', git: 'https://github.com/projectblacklight/blacklight-gallery.git' # Blacklight 7 support isn't in a gem yet
gem 'croutons'
gem 'devise'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'valkyrie'

# NEU gems
gem 'ace-rails-ap'
gem 'activerecord-session_store'
gem 'capybara'
gem 'devise-guests'
gem 'enumerations'
gem 'libera'
gem 'mailboxer'
gem 'minerva'
gem 'mods_display'
gem 'noid-rails'
gem 'rails-controller-testing'
gem 'rails-healthcheck'
gem 'simple_form'

# QA gems
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'simplecov', require: false
gem 'simplecov-shields-badge', require: false

# Rails gems
gem 'bootsnap'
gem 'sass-rails'

# Blacklight
gem 'bootstrap', '~> 4.0'
gem 'jquery-rails'
gem 'rsolr'
gem 'twitter-typeahead-rails'

# Blacklight
group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '5.0.1' # pinning due to Strategy not registered error
  gem 'rspec-rails'
end

group :development do
  gem 'byebug'
  gem 'listen'
  gem 'pry'
end

group :development, :staging, :test do
  gem 'faker', '1.9.1'
end
