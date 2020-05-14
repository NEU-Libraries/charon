# frozen_string_literal: true

class ThumbnailService
  include MimeHelper

  def initialize(params)
    @upload = GenericUpload.find(params[:upload_id])
    @work = Work.find(params[:work_id])
    @file_set = FileSet.find(params[:file_set_id])
  end

  def create_thumbnail
    # if determine_mime(@generic_upload.file).subtype == "pdf"
    thumbnail_path = make_jp2

    return if thumbnail_path.blank?

    blob_id = make_thumbnail_blob(thumbnail_path)
    add_thumbnail_blob_to_work(blob_id)
    @work.thumbnail = true
    Valkyrie.config.metadata_adapter.persister.save(resource: @work)
  end

  private

    def make_jp2
      # create thumbnail derivative for IIIF
      return if find_path.blank?

      i = Image.read(find_path).first

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

    def process_pdf
      pdf = Magick::ImageList.new(@upload.file.path + '[0]') do
        self.density = 300
        self.quality = 100
      end
      page_img = pdf.first

      page_img.border!(0, 0, 'white')
      page_img.alpha(Magick::DeactivateAlphaChannel)

      file_path = "/home/charon/images/#{@work.id}-pdf-page-0.png"

      page_img.write(file_path) { self.depth = 8 }
      file_path
    end

    def find_path
      path = ''
      if determine_mime(@upload.file).subtype == 'pdf'
        path = process_pdf
      elsif determine_mime(@upload.file).image?
        path = @upload.file.path
      end
      path
    end
end
