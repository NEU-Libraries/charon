# frozen_string_literal: true

Noid::Rails.configure do |config|
  if !Rails.env.test?
    config.minter_class = Noid::Rails::Minter::Db
    config.template = '.reeeeeek'
  end
end

::Minter = Noid::Rails::Service.new
