# frozen_string_literal: true

require 'rails_helper'

describe GenericUploadsController do
  describe 'new' do
    it 'renders the new record form' do
      get :new
      expect(response).to render_template('generic_uploads/new')
    end
  end

  describe 'index' do
    it 'renders the index' do
      get :index
      expect(response).to render_template('generic_uploads/index')
    end
  end
end
