# frozen_string_literal: true

class LiberaService
  def initialize(params)
    @work = Work.find(params[:work_id])
    @blob = Blob.find(params[:blob_id])

    Libera.configuration.working_dir = Rails.root.join('tmp').to_s + "/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
    @parser = Libera::Parser.new
    @parser.mk_working_dir
    @file_list = []
    @page_list = {}
  end

  def run
    create_file_set

    reader = PDF::Reader.new(@blob.file_path)
    @page_count = reader.page_count - 1

    (0..@page_count).each do |i|
      read_page(i)
    end

    @parser.generate_tei(@page_list)
  end

  private

    def create_file_set
      @file_set = FileSet.new type: Classification.derivative.name
      @file_set.a_member_of = @work.id
      Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    end

    def create_derivative_blob(file)
      blob_derivative = Blob.new
      blob_derivative.file_identifier = file.id # what does this mean in this context?
      blob_derivative.use = [Valkyrie::Vocab::PCDMUse.ServiceFile]
      Valkyrie.config.metadata_adapter.persister.save(resource: blob_derivative)
    end

    def create_file(file, file_name)
      Valkyrie.config.storage_adapter.upload(
        file: file, # tei, png, txt
        resource: @file_set,
        original_filename: file_name
      )
    end

    def read_page(page_number)
      pdf = Magick::ImageList.new(@blob.file_path + "[#{page_number}]")
      page_img = pdf.first

      page_img.border!(0, 0, 'white')
      page_img.alpha(Magick::DeactivateAlphaChannel)

      parse_page(page_number, page_img)
    ensure
      pdf.destroy! && page_img.destroy!
    end

    def populate_file_set(page_file)
      @file_set.member_ids += [create_derivative_blob(page_file).id]
      Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    end

    def parse_page(page_number, page_img)
      image_file_name = "pdf-page-#{page_number}.#{Libera.configuration.format_type}"
      image_file_path = "#{Libera.configuration.working_dir}/#{image_file_name}"

      @file_list << image_file_path
      page_img.write(image_file_path) { self.depth = 8 }

      page_file = create_file(File.open(image_file_path), image_file_name)
      populate_file_set(page_file)

      txt = @parser.parse_image(image_file_path, page_number)
      @page_list[image_file_name] = txt
      parse_image(page_number)
    end

    def parse_image(page_number)
      text_file_name = "pdf-page-#{page_number}.txt"
      text_file_path = "#{Libera.configuration.working_dir}/#{text_file_name}"
      text_file = create_file(File.open(text_file_path), text_file_name)
      populate_file_set(text_file)
    end
end
