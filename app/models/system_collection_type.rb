# frozen_string_literal: true

class SystemCollectionType < Enumerations::Base
  value :incoming,  name: 'Incoming'
  value :odd,       name: 'ODD'
  value :schema,    name: 'Schema'
  value :auxiliary, name: 'Auxiliary'
  value :works,     name: 'Works'
  value :xslt,      name: 'XSLT'
  value :css,       name: 'CSS'
end
