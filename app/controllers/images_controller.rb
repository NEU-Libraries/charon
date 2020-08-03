# frozen_string_literal: true

class ImagesController < ApplicationController
  def manifest
    render json: IiifService.new({ file_set_id: params[:id] }).run
  end
end
