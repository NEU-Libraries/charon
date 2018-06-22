class Page < ActiveFedora::Base
  include ::Hyrax::FileSetBehavior

  property :page_number, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/pageNumber'), multiple: false do |index|
    index.as :stored_searchable
    index.type :integer
  end
  property :text, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/pageText'), multiple: false do |index|
    index.as :stored_searchable
  end

  def page?
    true
  end
end
