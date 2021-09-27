# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    # convert notes to consumbale JSON
    page = Page.find(params[:id])
    note_hsh = {}
    note_hsh[:notes] = []
    page.notes.each do |n|
      note_vals = {
        'noid' => n.noid,
        'color' => n.color,
        'region' => JSON.parse(n.region)
      }
      note_hsh[:notes] << note_vals
    end
    respond_to do |format|
      format.json { render json: note_hsh }
    end
  end
end
