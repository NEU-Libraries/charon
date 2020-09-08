# frozen_string_literal: true

class LiberaService
  def initialize(params)
    @work = Work.find(params[:work_id])
    @blob = Blob.find(params[:blob_id])

    @stack = make_stack

    Libera.configuration.working_dir = Rails.root.join('tmp').to_s + "/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
    @parser = Libera::Parser.new
    @parser.mk_working_dir
    @file_list = []
    @page_list = {}
  end

  def run
    reader = PDF::Reader.new(@blob.file_path)
    @page_count = reader.page_count - 1

    (0..@page_count).each do |i|
      @page_number = i
      make_file_set
      make_png
      make_jp2
      make_txt
    end

    make_tei
  end

  private

    def image_file_name
      "pdf-page-#{@page_number}.#{Libera.configuration.format_type}"
    end

    def image_file_path
      "#{Libera.configuration.working_dir}/#{image_file_name}"
    end

    def make_file_set
      fs = FileSet.new type: Classification.derivative.name
      fs.a_member_of = @stack.id
      @file_set = Valkyrie.config.metadata_adapter.persister.save(resource: fs)
    end

    def make_png
      pdf = Magick::ImageList.new(@blob.file_path + "[#{@page_number}]")
      page_img = pdf.first

      page_img.border!(0, 0, 'white')
      page_img.alpha(Magick::DeactivateAlphaChannel)

      @file_list << image_file_path
      page_img.write(image_file_path) { self.depth = 8 }

      populate_file_set(image_file_path)
    end

    def make_jp2
      jp2 = Image.read(image_file_path).first
      jp2.format = 'JP2'
      jp2_file_name = "pdf-page-#{@page_number}.jp2"
      jp2_path = "/home/charon/images/#{jp2_file_name}" # not any more - need tmp dir
      jp2.write(jp2_path)

      populate_file_set(jp2_path)
    end

    def make_txt
      txt = @parser.parse_image(image_file_path, @page_number)
      @page_list[image_file_name] = txt

      text_file_name = "pdf-page-#{@page_number}.txt"
      text_file_path = "#{Libera.configuration.working_dir}/#{text_file_name}"

      populate_file_set(text_file_path)
    end

    def make_tei
      make_file_set # TEI needs it's own file_set

      @parser.generate_tei(@page_list)

      tei_path = "#{Libera.configuration.working_dir}/tei.xml"

      populate_file_set(tei_path)
    end

    def make_stack
      Valkyrie.config.metadata_adapter.persister.save(
        resource: Stack.new(
          type: Classification.text.name,
          a_member_of: @work.id
        )
      )
    end

    def create_derivative_blob(file_id, file_name)
      blob_derivative = Blob.new
      blob_derivative.original_filename = file_name
      blob_derivative.file_identifier = file_id # what does this mean in this context?
      blob_derivative.use = [Valkyrie::Vocab::PCDMUse.ServiceFile]
      Valkyrie.config.metadata_adapter.persister.save(resource: blob_derivative)
    end

    def create_valkyrie_file(file_path)
      Valkyrie.config.storage_adapter.upload(
        file: File.open(file_path), # tei, png, txt
        resource: @file_set,
        original_filename: file_path.split('/').last
      )
    end

    def populate_file_set(file_path)
      @file_set.member_ids += [
        create_derivative_blob(create_valkyrie_file(file_path).id,
                               file_path.split('/').last).id
      ]
      @file_set = Valkyrie.config.metadata_adapter.persister.save(resource: @file_set)
    end
end
