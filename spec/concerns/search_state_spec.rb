# frozen_string_literal: true

require 'spec_helper'

describe SearchState do
  let(:params) { ActionController::Parameters.new }
  let(:config) { Blacklight::Configuration.new }
  let(:controller) { double }
  let(:search_state) { described_class.new(params, config, controller) }
  let(:noid) { Minter.mint }
  let(:doc) { SolrDocument.new(id: '1', internal_resource_tesim: ['Project'], alternate_ids_tesim: [noid]) }

  describe '#url_for_document defaults to doc' do
    subject { search_state.url_for_document(SolrDocument.new) }
    it { is_expected.to be_kind_of SolrDocument }
  end

  describe '#url_for_document reacts to klass' do
    subject { search_state.url_for_document(doc) }
    it { is_expected.to eq("/projects/#{noid}") }
  end
end
