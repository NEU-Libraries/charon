class GenericUploadsController < ApplicationController
  def new
    @generic_upload = GenericUpload.new
  end

  def create
    puts params.inspect

    gu = GenericUpload.new(params[:generic_upload].permit({generics: []}))
    gu.save!

    puts gu.generics[0].url # => '/url/to/file.png'
    puts gu.generics[0].current_path # => 'path/to/file.png'
    puts gu.generics[0].identifier # => 'file.png'
  end
end
