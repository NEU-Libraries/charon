# frozen_string_literal: true

source 'https://rubygems.org'

gem 'blacklight', '7.1.0.alpha'
gem 'blacklight-access_controls', git: 'https://github.com/projectblacklight/blacklight-access_controls.git'
gem 'blacklight-gallery', git: 'https://github.com/projectblacklight/blacklight-gallery.git' # Blacklight 7 support isn't in a gem yet
gem 'devise'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'valkyrie', '2.0.0.RC9'

# NEU gems
gem 'capybara'
gem 'devise-guests'
gem 'enumerations'
gem 'libera'
gem 'minerva'
gem 'noid-rails'
gem 'rails-controller-testing'
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
gem 'turbolinks'
gem 'twitter-typeahead-rails'

# Blacklight
group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '5.0.1' # pinning due to Strategy not registered error
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
end

group :development, :staging, :test do
  gem 'faker', '1.9.1'
end
