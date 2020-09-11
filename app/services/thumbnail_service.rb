# frozen_string_literal: true

class ThumbnailService
  include MimeHelper

  def initialize(params)
    @upload = GenericUpload.find(params[:upload_id])
    @work = Work.find(params[:work_id])
    @file_set = FileSet.find(params[:file_set_id])
  rescue Valkyrie::Persistence::ObjectNotFoundError, ActiveRecord::RecordNotFound => e
    Rails.logger.error(e)
  end

  def run
    return if @upload.nil? || @work.nil? || @file_set.nil?
    return if @work.thumbnail.present? # idempotent step

    thumbnail_path = make_jp2

    return if thumbnail_path.blank?

    blob_id = make_thumbnail_blob(thumbnail_path)
    add_thumbnail_blob_to_work(blob_id)
    @work.thumbnail = blob_id
    Valkyrie.config.metadata_adapter.persister.save(resource: @work)
    GenericUpload.find(@upload.id).destroy!
  end

  private

    def make_jp2
      # create thumbnail derivative for IIIF
      return if find_path.blank?

      i = Image.read(find_path).first

      i.format = 'JP2'
      thumbnail_path = Rails.root.join('tmp').to_s + "/#{SecureRandom.uuid}.jp2"
      i.write(thumbnail_path)
      thumbnail_path
    end

    def make_thumbnail_blob(thumbnail_path)
      thumbnail_blob = Blob.new
      thumbnail_blob.original_filename = thumbnail_path.split('/').last
      thumbnail_blob.file_identifier = create_valkyrie_file(thumbnail_path).id
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
      pdf = Magick::ImageList.new("#{@upload.file.path}[0]") do
        self.density = 300
        self.quality = 100
      end
      page_img = pdf.first

      page_img.border!(0, 0, 'white')
      page_img.alpha(Magick::DeactivateAlphaChannel)

      file_path = Rails.root.join('tmp').to_s + "/#{SecureRandom.uuid}.png"

      page_img.write(file_path) { self.depth = 8 }
      file_path
    end

    def create_valkyrie_file(file_path)
      Valkyrie.config.storage_adapter.upload(
        file: File.open(file_path),
        resource: @file_set,
        original_filename: file_path.split('/').last
      )
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
