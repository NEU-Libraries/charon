# frozen_string_literal: true

module ThumbnailHelper
  def make_thumbnail(resource, params)
    return if params.blank? # TODO: need to do an actual thumbnail check

    gu = GenericUpload.new(params)
    gu.user = current_user
    gu.save!

    file_set = FileSet.new type: determine_classification(gu.file_path)
    Valkyrie.config.metadata_adapter.persister.save(resource: file_set)

    CreateBlobJob.perform_later(resource.noid, gu.id, file_set.noid)
  end
end
