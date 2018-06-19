class GenericUploadsController < ApplicationController
  def new
    @generic_upload = GenericUpload.new
  end
end
