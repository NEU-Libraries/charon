# Generated via
#  `rails generate hyrax:work Composition`
class Composition < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  filters_association :members, as: :pages, condition: :page?

  self.indexer = CompositionIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  has_many :pages

  def page?
    false
  end
end
