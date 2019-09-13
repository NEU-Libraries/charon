# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @notifications = current_user.mailbox.notifications
    @unread_ids = current_user.mailbox.notifications(unread: true).pluck(:id)
  end

  def mark_as_read
     Mailboxer::Notification.find(params[:id]).mark_as_read(current_user)
     flash[:notice] = "Notification marked as read."
     redirect_to notifications_path
  end

  def mark_all_as_read
     current_user.mailbox.notifications.each do |notification|
       notification.mark_as_read(current_user)
     end
     flash[:notice] = "All notifications marked as read."
     redirect_to notifications_path
  end
end
