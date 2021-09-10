# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    # id = page_id
    note = Note.new(a_member_of: params[:page_id])
    saved_note = Valkyrie.config.metadata_adapter.persister.save(resource: note)
    respond_to do |format|
      format.json { render json: { id: saved_note.noid } }
    end
  end
end
