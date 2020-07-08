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
    (0..@page_count).each do |i|
      read_page(i)
    end

    @parser.generate_tei(@page_list)
  end

  private

    def read_page(page_number)
      pdf = Magick::ImageList.new(@blob.file_path + "[#{page_number}]")
      page_img = pdf.first

      page_img.border!(0, 0, 'white')
      page_img.alpha(Magick::DeactivateAlphaChannel)

      parse_page(page_number, page_img)
    ensure
      pdf.destroy! && page_img.destroy!
    end

    def parse_page(page_number, page_img)
      file_name = "pdf-page-#{page_number}.#{Libera.configuration.format_type}"

      dir_path = "#{Libera.configuration.working_dir}/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
      FileUtils.mkdir_p dir_path

      file_path = "#{dir_path}/#{file_name}"

      @file_list << file_path
      page_img.write(file_path) { self.depth = 8 }

      txt = @parser.parse_image(file_path, page_number)
      @page_list[file_name] = txt
    end
end
