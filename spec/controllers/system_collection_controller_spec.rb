# frozen_string_literal: true

require 'rails_helper'

describe SystemCollectionsController do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:system_collection) { project.children.first }

  describe 'show' do
    render_views
    it 'renders the show partial if the user has access' do
      expect(system_collection.public?).to be true
      get :show, params: { id: system_collection.noid }
      expect(response).to render_template('system_collections/show')
    end
  end
end
