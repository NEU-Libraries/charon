# frozen_string_literal: true

require 'rails_helper'

describe GenericUploadsController do
  describe 'new' do
    it 'renders the new record form' do
      get :new
      expect(response).to render_template('generic_uploads/new')
    end
  end
end
