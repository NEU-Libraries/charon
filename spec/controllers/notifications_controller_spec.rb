# frozen_string_literal: true

require 'rails_helper'

describe NotificationsController do
  let(:user) { create(:user) }

  describe 'index' do
    render_views
    it 'renders all the users notifications' do
      sign_in user
      get :index
      expect(CGI.unescapeHTML(response.body)).to include('Notifications')
    end
  end

  describe 'mark_as_read' do
    it 'modifies the specified notication so that it is read' do
      user.notify('Test Subject', 'Test Body')
      expect(user.mailbox.notifications.count).to eq(1)
      expect(user.mailbox.notifications(unread: true).count).to eq(1)

      notification = user.mailbox.notifications.first

      sign_in user
      get :mark_as_read, params: { id: notification.id }
      expect(user.mailbox.notifications(unread: true).count).to eq(0)
    end
  end

  describe 'mark_all_as_read' do
    it 'modifies all of a users notifications so that they are read' do
      user.notify('Test Subject 1', 'Test Body 1')
      user.notify('Test Subject 2', 'Test Body 2')
      user.notify('Test Subject 3', 'Test Body 3')
      expect(user.mailbox.notifications(unread: true).count).to eq(3)

      sign_in user
      get :mark_all_as_read
      expect(user.mailbox.notifications(unread: true).count).to eq(0)
    end
  end
end
