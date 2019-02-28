# frozen_string_literal: true

source 'https://rubygems.org'

gem 'blacklight', '7.0.1'
gem 'blacklight-access_controls'
gem 'blacklight-gallery', git: 'https://github.com/projectblacklight/blacklight-gallery.git' # Blacklight 7 support isn't in a gem yet
gem 'carrierwave'
gem 'devise'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'pg'
gem 'rails'
gem 'valkyrie', '1.5.1'

# NEU gems
gem 'libera'
gem 'minerva'

# Rails gems
gem 'bootsnap'
gem 'sass-rails'

group :development do
  gem 'listen'
end

# Blacklight
gem 'bootstrap', '~> 4.0'
gem 'jquery-rails'
gem 'popper_js'
gem 'rsolr', '>= 1.0', '< 3'
gem 'turbolinks'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'

# Blacklight
group :development, :test do
  gem 'rspec-rails'
  gem 'solr_wrapper', '>= 0.3'
end

group :test do
  gem 'rubocop', require: false
  gem 'simplecov', require: false
  gem 'simplecov-shields-badge', require: false
end
