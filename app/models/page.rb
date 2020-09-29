# frozen_string_literal: true

class Page < FileSet
  attribute :text, Valkyrie::Types::String

  def thumbnail
    files.select do |f|
      f.use == [Valkyrie::Vocab::PCDMUse.ThumbnailImage]
    end.first.noid
  end
end
