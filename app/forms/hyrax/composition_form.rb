# Generated via
#  `rails generate hyrax:work Composition`
module Hyrax
  # Generated form for Composition
  class CompositionForm < Hyrax::Forms::WorkForm
    self.model_class = ::Composition
    self.terms += [:resource_type]
  end
end
