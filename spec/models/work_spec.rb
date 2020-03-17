# frozen_string_literal: true

# Generated with `rails generate valkyrie:model Work`
require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work do
  let(:resource_klass) { described_class }
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:document) { SolrDocument.new Valkyrie::MetadataAdapter.find(:index_solr).resource_factory.from_resource(resource: work) }
  it_behaves_like 'a Valkyrie::Resource'

  it 'has a helper method for finding the project it belongs to' do
    expect(work.project.works.first).to eq work
  end

  it 'has a thumbnail boolean that works with solr' do
    expect(document.thumbnail?).to be true
  end
end
