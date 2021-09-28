# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @note = Note.find(params[:note_id])
    comment = Comment.new(a_member_of: params[:note_id], message: params[:comment])
    @saved_comment = Valkyrie.config.metadata_adapter.persister.save(resource: comment)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
  end
end
