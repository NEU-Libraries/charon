# frozen_string_literal: true

class Capacity < Enumerations::Base
  value :system,          name: 'System'
  value :developer,       name: 'Developer'
  value :administrator,   name: 'Administrator'
  value :user,            name: 'User'
end
