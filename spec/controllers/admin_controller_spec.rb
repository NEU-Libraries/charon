# frozen_string_literal: true

require 'rails_helper'

describe AdminController do
  describe 'dashboard' do
    it '401s unless signed in' do
      get :dashboard
      expect(response.status).to eq(401)
    end

    it '403s unless user is an admin' do
      sign_in FactoryBot.create(:user)
      get :dashboard
      expect(response.status).to eq(403)
    end
  end
end
