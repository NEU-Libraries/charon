# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    # comment = Comment.new(a_member_of: params[:note_id])
    # saved_comment = Valkyrie.config.metadata_adapter.persister.save(resource: comment)
    # respond_to do |format|
    #   format.json { render json: { id: saved_comment.noid } }
    # end
    logger.info params.inspect
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy

    respond_to do |format|
      format.json { render json: { deleted: 'true' } }
    end
  end
end
