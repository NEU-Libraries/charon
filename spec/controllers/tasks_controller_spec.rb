# frozen_string_literal: true

require 'rails_helper'

describe TasksController do
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:blob) { FactoryBot.create_for_repository(:blob, :pdf) }
  let(:libera_service) { LiberaService.new({ work_id: work.id, blob_id: blob.id }) }

  describe 'claim' do
    render_views
    it 'renders a list of actions available from the workflow' do
      get :claim, params: { id: work.noid }
      expect(response).to render_template('tasks/claim')
      # TODO: test permissions
      # TODO enumerate expected tasks
    end
  end

  describe 'catalog' do
    render_views
    it 'renders an XML editor for this works MODS' do
      create_interfaces

      sign_in FactoryBot.create(:user)
      get :catalog, params: { id: work.noid }
      expect(response).to render_template('tasks/catalog')
      # TODO: further testing
    end
  end

  describe 'update_work' do
    it 'alters a work\'s title' do
      put :update_work, params: { id: work.id, work: { title: 'new title' } }
      expect(Work.find(work.noid).title).to eq('new title')
    end

    it 'alters a work\'s MODS' do
      new_mods = '<?xml version="1.0" encoding="UTF-8"?>
        <mods:mods xmlns:drs="https://repository.neu.edu/spec/v1" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:niec="http://repository.neu.edu/schema/niec" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dwc="http://rs.tdwg.org/dwc/terms/" xmlns:dwr="http://rs.tdwg.org/dwc/xsd/simpledarwincore/" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
          <mods:titleInfo usage="primary">
            <mods:title>MODS title</mods:title>
          <mods:nonSort/></mods:titleInfo>
        </mods:mods>'
      put :update_work, params: { id: work.id, work: { mods_xml: new_mods } }
      expect(Work.find(work.noid).mods_xml).to eq(new_mods)
      expect(Work.find(work.noid).title).to eq('MODS title')
    end
  end

  describe 'update_page' do
    it 'updates the page object with new transcribed text' do
      libera_service.run unless work.children.count > 0
      stack = work.children[0]
      page = stack.children.select { |c| c.class == Page }.first
      put :update_page, params: { id: page.id, page_text: 'foo' }
      expect(Page.find(page.id).text).to eq('foo')
    end
  end

  describe 'transcribe' do
    render_views
    it 'renders' do
      libera_service.run unless work.children.count > 0
      get :transcribe, params: { id: work.noid }
      expect(response).to render_template('tasks/transcribe')
      # TODO: further testing
    end
  end

  describe 'encode' do
    render_views
    it 'renders' do
      get :encode, params: { id: work.noid }
      expect(response).to render_template('tasks/encode')
      # TODO: further testing
    end
  end

  describe 'review' do
    render_views
    it 'renders' do
      get :review, params: { id: work.noid }
      expect(response).to render_template('tasks/review')
      # TODO: further testing
    end
  end

  describe 'publish' do
    render_views
    it 'renders' do
      get :publish, params: { id: work.noid }
      expect(response).to render_template('tasks/publish')
      # TODO: further testing
    end
  end
end
