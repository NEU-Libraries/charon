# frozen_string_literal: true

class ImagesController < ApplicationController
  def manifest
    render json: IiifService.new({ stack_id: params[:id] }).run
  end

  def single_manifest
    render json: IiifService.new({ blob_id: params[:id] }).run
  end
end
