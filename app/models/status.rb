# frozen_string_literal: true

class Status < Enumerations::Base
  value :in_progress,   name: 'In Progress'
  value :inactive,      name: 'Inactive'
  value :complete,      name: 'Complete'
  value :under_review,  name: 'Under Review'
  value :available,     name: 'Available'
  value :edited,        name: 'Edited'
  value :finished,      name: 'Finished'
  value :approved,      name: 'Approved'
  value :denied,        name: 'Denied'
end
