# frozen_string_literal: true

class Task < Enumerations::Base
  value :transcribe,  name: 'Transcribe'
  value :encode,      name: 'Encode'
  value :catalog,     name: 'Catalog'
  value :review,      name: 'Review'
  value :publish,     name: 'Publish'
end
