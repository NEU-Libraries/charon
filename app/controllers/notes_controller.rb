# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @page = Page.find(params[:page_id])
    note = Note.new(alternate_ids: [Valkyrie::ID.new(params[:noid])],
                    a_member_of: params[:page_id],
                    region: params[:latlng],
                    color: params[:color])
    Valkyrie.config.metadata_adapter.persister.save(resource: note)
    respond_to do |format|
      format.js { render 'notes/_table', layout: false and return }
    end
  end

  def destroy
    note = Note.find(params[:id])
    @page = note.parent
    Valkyrie.config.metadata_adapter.persister.delete(resource: note)

    respond_to do |format|
      format.js { render 'notes/_table', content_type: 'text/html', layout: false and return }
    end
  end
end
