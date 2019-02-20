class SearchState < Blacklight::SearchState
  include Rails.application.routes.url_helpers

  def url_for_document(doc, options = {})

    if doc.respond_to?(:human_readable_type) && !doc.human_readable_type.blank?
      # I know this wrong, but I don't know what's right - however, the end result works ¯\_(ツ)_/¯
      return send(doc.human_readable_type.downcase + "_path", doc.id)
    end

    super
  end
end
