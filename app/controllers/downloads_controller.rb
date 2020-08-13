# frozen_string_literal: true

class DownloadsController < ApplicationController
  def download
    # take noid of blob and send file on file path
    send_file Blob.find(params[:id]).file_path
  end
end
