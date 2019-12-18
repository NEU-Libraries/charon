# frozen_string_literal: true

require 'rails_helper'

describe TasksController do
  let(:work) { FactoryBot.create_for_repository(:work) }

  describe 'claim' do
    render_views
    it 'renders a list of actions available from the workflow' do
      get :claim, params: { id: work.noid }
      expect(response).to render_template('tasks/claim')
      # TODO test permissions
      # TODO enumerate expected tasks
    end
  end

  describe 'catalog' do
    render_views
    it 'renders an XML editor for this works MODS' do
      # TODO make these in a helper method for all rspec tests
      Minerva::Interface.create(title: "upload", code_point: "generic_uploads#new")
      Minerva::Interface.create(title: "catalog", code_point: "catalog#catalog")

      sign_in FactoryBot.create(:user)
      get :catalog, params: { id: work.noid }
      expect(response).to render_template('tasks/catalog')
      # TODO further testing
    end
  end
end
