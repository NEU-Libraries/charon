# frozen_string_literal: true

class Designation < Enumerations::Base
  value :manager,   name: 'Manager'
  value :editor,    name: 'Editor'
  value :creator,   name: 'Creator'
  value :depositor, name: 'Depositor'
  value :user,      name: 'User'
end
