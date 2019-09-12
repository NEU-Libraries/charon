# frozen_string_literal: true

class MailboxerController < ApplicationController
  def inbox_index
  end

  def notifications_index
    @notifications = current_user.mailbox.notifications
    @unread_ids = current_user.mailbox.notifications(unread: true).pluck(:id)
  end
end
