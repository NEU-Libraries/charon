class GenericUploadsController < ApplicationController
  def new
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit({generics: []}))
    gu.save!

    redirect_to action: "index"
  end

  def index
    # u.avatars[0].identifier # => 'file.png'
    puts "DGC DEBUG: #{GenericUpload.count}"
    @uploads = GenericUpload.all
  end

  def show
  end

  def generate_composition
    gu = GenericUpload.find(params[:id])
    pdf_path = gu.generics.first.file.path
    comp = Composition.create(:title => ["Test Composition"])
    working_dir = "#{Rails.root}/tmp/libera-#{Time.now.to_f.to_s.gsub!('.','')}"
    GenerateCompositionJob.perform_later(comp.id, pdf_path, working_dir)
  end
end
