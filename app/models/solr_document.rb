# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  attribute :klass_type, Blacklight::Types::String, 'internal_resource_tesim'
  attribute :human_readable_type, Blacklight::Types::String, 'human_readable_type_ssim'
  attribute :alternate_ids, Blacklight::Types::Array, 'alternate_ids_tesim'
  attribute :thumbnail, Blacklight::Types::Array, 'thumbnail_tesim'
  attribute :system_collection_type, Blacklight::Types::String, 'system_collection_type_tesim'

  def klass
    # kludge for preferred type - collection controller links
    return 'Collection'.constantize if system_collection_type.present?
    return klass_type.constantize if klass_type.present?
  end

  def to_param
    noid = alternate_ids&.first&.split('id-')&.last
    return noid if noid.present?

    super
  end

  def thumbnail?
    return false if thumbnail.blank?

    true
  end
end
