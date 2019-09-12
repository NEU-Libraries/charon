# frozen_string_literal: true

class MailboxerController < ApplicationController
  def inbox_index
  end

  def notifications_index
    @notifications = current_user.mailbox.notifications
    @unread_ids = current_user.mailbox.notifications(unread: true).pluck(:id)
  end

  def mark_notification_as_read
     Mailboxer::Notification.find(params[:id]).mark_as_read(current_user)
     flash[:notice] = "Message marked as read."
     redirect_to users_notifications_path
  end
end
