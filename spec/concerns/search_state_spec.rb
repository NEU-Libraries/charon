# frozen_string_literal: true

require 'spec_helper'

describe SearchState do
  let(:params) { ActionController::Parameters.new }
  let(:config) { Blacklight::Configuration.new }
  let(:controller) { double }
  let(:search_state) { described_class.new(params, config, controller) }
  let(:noid) { Minter.mint }
  let(:human_readable_doc) { SolrDocument.new(id: '1', human_readable_type_ssim: ['Project'], alternate_ids_tesim: [noid]) }

  describe '#url_for_document defaults to doc' do
    subject { search_state.url_for_document(SolrDocument.new) }
    it { is_expected.to be_kind_of SolrDocument }
  end

  describe '#url_for_document reacts to human readable type' do
    subject { search_state.url_for_document(human_readable_doc) }
    it { is_expected.to eq("/projects/#{noid}") }
  end
end
