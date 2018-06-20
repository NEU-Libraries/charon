class GenericUploadsController < ApplicationController
  def new
    @generic_upload = GenericUpload.new
  end

  def create
    gu = GenericUpload.new(params[:generic_upload].permit({generics: []}))
    gu.save!

    render 'index'
  end

  def index
  end

  def show
  end
end
