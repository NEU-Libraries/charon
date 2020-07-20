# frozen_string_literal: true

class LiberaService
  def initialize(params)
    @work = Work.find(params[:work_id])
    @blob = Blob.find(params[:blob_id])

    @parser = Libera::Parser.new
    @parser.mk_working_dir
    @file_list = []
    reader = PDF::Reader.new(@blob.file_path)
    @page_count = reader.page_count - 1
    @page_list = {}
  end

  def run
    create_file_set

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
      file_name = "pdf-page-#{page_number}.#{Libera.configuration.format_type}"

      dir_path = "#{Libera.configuration.working_dir}/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
      FileUtils.mkdir_p dir_path

      file_path = "#{dir_path}/#{file_name}"

      @file_list << file_path
      page_img.write(file_path) { self.depth = 8 }

      page_file = create_file(File.open(file_path), file_name)
      populate_file_set(page_file)

      txt = @parser.parse_image(file_path, page_number)
      @page_list[file_name] = txt
    end
end
