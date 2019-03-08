# frozen_string_literal: true

class Capacity < Enumerations::Base
  value :developer,       name: 'Developer'
  value :administrator,   name: 'Administrator'
  value :user,            name: 'User'
end
