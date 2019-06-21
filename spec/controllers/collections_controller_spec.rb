# frozen_string_literal: true

require 'rails_helper'

describe CollectionsController do
  let(:collection) { FactoryBot.create_for_repository(:collection) }

  describe 'show' do
    render_views
    it 'renders the show partial if the user has access' do
      expect(collection.public?).to be true
      get :show, params: { id: collection.noid }
      expect(response).to render_template('collections/show')
      expect(CGI.unescapeHTML(response.body)).to include(collection.title)
    end
  end
end
