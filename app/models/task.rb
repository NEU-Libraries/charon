# frozen_string_literal: true

class Task < Enumerations::Base
  value :transcribe,  name: 'Transcribe',   designation: Designation.creator
  value :encode,      name: 'Encode',       designation: Designation.creator
  value :catalog,     name: 'Catalog',      designation: Designation.creator
  value :review,      name: 'Review',       designation: Designation.editor
  value :publish,     name: 'Publish',      designation: Designation.editor
end
