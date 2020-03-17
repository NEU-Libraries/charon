# frozen_string_literal: true

class ThumbnailService
  def initialize(params)
    @upload = GenericUpload.find(params[:upload_id])
    @work = Work.find(params[:work_id])
    @file_set = FileSet.find(params[:file_set_id])
  end

  def create_thumbnail
    thumbnail_path = make_jp2
    blob_id = make_thumbnail_blob(thumbnail_path)
    add_thumbnail_blob_to_work(blob_id)
    @work.thumbnail = true
    Valkyrie.config.metadata_adapter.persister.save(resource: @work)
  end

  private

    def make_jp2
      # create thumbnail derivative for IIIF
      i = Image.read(@upload.file.path).first
      i.format = 'JP2'
      thumbnail_path = "/home/charon/images/#{@work.id}.jp2"
      i.write(thumbnail_path) # will need to do some unique filename to enable crosswalking back via pid
      thumbnail_path
    end

    def make_thumbnail_blob(thumbnail_path)
      thumbnail_blob = Blob.new
      thumbnail_blob.file_identifier = "disk://#{thumbnail_path}"
      thumbnail_blob.use = [Valkyrie::Vocab::PCDMUse.ThumbnailImage]
      saved_thumbnail_blob = Valkyrie.config.metadata_adapter.persister.save(resource: thumbnail_blob)
      saved_thumbnail_blob.id
    end

    def add_thumbnail_blob_to_work(blob_id)
      @file_set.member_ids += [blob_id]
      @file_set.a_member_of = @work.id
      Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    end
end
