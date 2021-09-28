# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    # convert notes to consumbale JSON
    page = Page.find(params[:id])
    respond_to do |format|
      format.json { render json: build_json(page) }
    end
  end

  private

    def build_json(page)
      note_hsh = { notes: [] }
      page.notes.each do |n|
        note_vals = {
          'noid' => n.noid,
          'color' => n.color,
          'region' => JSON.parse(n.region)
        }
        note_hsh[:notes] << note_vals
      end
      note_hsh
    end
end
