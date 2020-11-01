# frozen_string_literal: true

class LiberaService
  include ValkyrieHelper

  def initialize(params)
    @work = Work.find(params[:work_id])
    @blob = Blob.find(params[:blob_id])

    @stack = create_stack(@work.id)

    Libera.configuration.working_dir = Rails.root.join('tmp').to_s + "/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
    @parser = Libera::Parser.new
    @parser.mk_working_dir
    @file_list = []
  end

  def run
    reader = PDF::Reader.new(@blob.file_path)
    @page_count = reader.page_count - 1

    (0..@page_count).each do |i|
      @page_number = i
      make_page
      make_png
      make_jp2
      make_txt
    end

    # make_tei
    TeiService.new({ stack_id: @stack.noid }).run
  end

  private

    def image_file_name
      "pdf-page-#{@page_number}.#{Libera.configuration.format_type}"
    end

    def image_file_path
      "#{Libera.configuration.working_dir}/#{image_file_name}"
    end

    def make_page
      p = Page.new type: Classification.derivative.name
      p.a_member_of = @stack.id
      @page = Valkyrie.config.metadata_adapter.persister.save(resource: p)
    end

    def make_png
      pdf = Magick::ImageList.new(@blob.file_path + "[#{@page_number}]") do
        self.density = 300
        self.quality = 100
      end

      page_img = pdf.first

      page_img.border!(0, 0, 'white')
      page_img.alpha(Magick::DeactivateAlphaChannel)

      @file_list << image_file_path
      page_img.write(image_file_path) { self.depth = 8 }

      populate_resource(image_file_path, @page)
    end

    def make_jp2
      jp2 = Image.read(image_file_path).first
      jp2.format = 'JP2'
      jp2_file_name = "pdf-page-#{@page_number}.jp2"
      jp2_path = "#{Libera.configuration.working_dir}/#{jp2_file_name}"
      jp2.write(jp2_path)

      populate_resource(jp2_path, @page, Valkyrie::Vocab::PCDMUse.ThumbnailImage)
    end

    def make_txt
      txt = @parser.parse_image(image_file_path, @page_number)

      text_file_name = "pdf-page-#{@page_number}.txt"
      text_file_path = "#{Libera.configuration.working_dir}/#{text_file_name}"

      @page.text = txt
      @page = Valkyrie.config.metadata_adapter.persister.save(resource: @page)

      populate_resource(text_file_path, @page)
    end

    def populate_resource(file_path, resource, use = Valkyrie::Vocab::PCDMUse.ServiceFile)
      resource.member_ids += [
        create_blob(create_file(file_path, resource).id, file_path.split('/').last, use).id
      ]
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end
end
