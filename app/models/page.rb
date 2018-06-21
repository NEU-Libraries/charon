class Page < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include Hydra::PCDM::ObjectBehavior

  belongs_to :composition, :class_name => "Composition", predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf
end
