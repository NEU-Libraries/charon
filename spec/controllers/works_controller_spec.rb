# frozen_string_literal: true

require 'rails_helper'

describe WorksController do
  let(:work) { FactoryBot.create_for_repository(:work) }

  describe 'show' do
    render_views
    it 'renders a works title' do
      get :show, params: { id: work.noid }
      expect(response).to render_template('works/show')
      expect(CGI.unescapeHTML(response.body)).to include(work.title)
    end
  end

  describe 'history' do
    render_views
    it 'renders a list of actions taken for a work' do
      get :history, params: { id: work.noid }
      expect(response).to render_template('works/history')
    end
  end
end
