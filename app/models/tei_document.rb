class TeiDocument < FileSet
  property :text, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/teiText'), multiple: false do |index|
    index.as :stored_searchable
  end
end
