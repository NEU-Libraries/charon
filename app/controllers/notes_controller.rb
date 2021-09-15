# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @page = Page.find(params[:page_id])
    note = Note.new(a_member_of: params[:page_id])
    Valkyrie.config.metadata_adapter.persister.save(resource: note)
    logger.info(params.inspect)
    respond_to do |format|
      format.js { render 'notes/_table', layout: false and return }
    end
  end

  def destroy
    note = Note.find(params[:id])
    note.destroy

    respond_to do |format|
      format.json { render json: { deleted: 'true' } }
    end
  end
end
