# frozen_string_literal: true

class SearchState < Blacklight::SearchState
  include Rails.application.routes.url_helpers

  def url_for_document(doc, options = {})
    if doc.respond_to?(:klass) && !doc.klass.blank?
      return send(ActiveModel::Naming.singular_route_key(doc.klass) + '_path', doc)
    end

    super
  end
end
