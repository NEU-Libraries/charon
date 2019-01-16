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
end
