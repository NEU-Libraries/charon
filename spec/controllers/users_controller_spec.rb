# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  let!(:user) { FactoryBot.create(:user) }

  describe 'index' do
    render_views
    it 'displays the user' do
      get :index
      expect(response.body).to include(user.last_name)
    end
  end
end
