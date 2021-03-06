# frozen_string_literal: true

require 'database_cleaner'
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
