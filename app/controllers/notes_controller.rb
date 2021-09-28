# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @page = Page.find(params[:page_id])
    create_note
    respond_to do |format|
      format.js { render 'notes/_table', layout: false and return }
    end
  end

  def destroy
    @note = Note.find(params[:id])
    Valkyrie.config.metadata_adapter.persister.delete(resource: @note)
  end

  private

    def create_note
      note = Note.new(alternate_ids: [Valkyrie::ID.new(params[:noid])],
                      a_member_of: params[:page_id],
                      region: params[:latlng],
                      color: params[:color])
      Valkyrie.config.metadata_adapter.persister.save(resource: note)
    end
end
