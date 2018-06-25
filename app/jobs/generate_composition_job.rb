class GenerateCompositionJob < ApplicationJob
  queue_as :default

  def perform(composition_title, pdf_location, working_dir)
    comp = Composition.new(:title => ["#{composition_title}"])

    parser = Libera::Parser.new

    file_list = []

    reader = PDF::Reader.new(pdf_location)
    page_count = reader.page_count - 1

    progressbar = ProgressBar.create(:title => "Pages", :starting_at => 0, :total => page_count + 1)

    page_list = Hash.new

    for i in 0..page_count
      begin
        page = Page.create
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

    parser.generate_tei(page_list)
  end
end
