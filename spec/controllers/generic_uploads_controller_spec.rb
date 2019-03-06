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

  describe "create" do
    context "with valid input" do
      it "creates a generic upload" do
        file = fixture_file_upload(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png')
        expect { post :create, params: { generic_upload: { binary: file } } }.to change(ActiveStorage::Attachment, :count).by(1)
      end
    end
  end
end
