# frozen_string_literal: true

class Page < FileSet
  attribute :versioned_text, Valkyrie::Types::Array

  def thumbnail
    files.select do |f|
      f.use == [Valkyrie::Vocab::PCDMUse.ThumbnailImage]
    end.first.noid
  end

  def text
    versioned_text.last
  end

  def text=(text_value)
    self.versioned_text += [text_value]
  end
end
