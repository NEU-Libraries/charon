class GenerateCompositionJob < ApplicationJob
  queue_as :default

  def perform(composition_id, pdf_location, working_dir)
    if [composition_id, pdf_location, working_dir].any? {|arg| arg.blank?}
      raise "GenerateCompositionJob must have valid non-blank values for all arguments"
    end

    comp = Composition.find(composition_id)
    puts "Composition id: #{composition_id}"

    parser = Libera::Parser.new

    file_list = []

    reader = PDF::Reader.new(pdf_location)
    page_count = reader.page_count - 1

    progressbar = ProgressBar.create(:title => "Pages", :starting_at => 0, :total => page_count + 1)

    page_list = Hash.new

    for i in 0..page_count
      begin
        page = Page.create
        puts "Page id: #{page.id}"
        page.page_number = i + 1

        pdf = Magick::ImageList.new(pdf_location + "[#{i}]") {self.density = Libera.configuration.density; self.quality = Libera.configuration.quality}
        page_img = pdf.first

        page_img.border!(0, 0, 'white')
        page_img.alpha(Magick::DeactivateAlphaChannel)

        file_name = "pdf-page-#{i}.#{Libera.configuration.format_type}"
        file_path = "#{working_dir}/#{file_name}"

        file_list << file_path
        page_img.write(file_path) {self.depth = 8}

        txt = parser.parse_image(file_path, i)
        page_list[file_name] = txt

        Hydra::Works::UploadFileToFileSet.call(page, File.open(file_path))
        page.text = txt
        page.save!

        comp.members << page
      ensure
        pdf.destroy! && page_img.destroy!
      end
    end

    tei_doc = TeiDocument.create
    puts "Tei Doc id: #{tei_doc.id}"
    parser.generate_tei(page_list)

    tei_path = "#{working_dir}/tei.xml"
    tei_doc.text = File.read(tei_path)

    tei_doc.save!

    return comp
  end
end
