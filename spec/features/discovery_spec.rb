# frozen_string_literal: true

require 'spec_helper'

describe 'discovery' do
  let(:hidden_doc) do
    create_solr_doc(id: '321',
                    read_access_group_ssim: [],
                    title_tesim: ['not a discoverable document'])
  end

  let(:public_doc) do
    create_solr_doc(id: '999',
                    read_access_group_ssim: ['public'],
                    title_tesim: ['find me!'])
  end

  it 'should repond to catalog path' do
    visit search_catalog_path
    expect(page).to have_content 'Blacklight is a multi-institutional open-source collaboration'
  end

  it "should not show documents that aren't discoverable" do
    expect(hidden_doc.id).to eq '321'
    visit search_catalog_path q: '*:*'
    expect(page).to have_no_content 'not a discoverable document'
  end

  it 'should show documents that are discoverable' do
    expect(public_doc.id).to eq '999'
    visit search_catalog_path q: '*:*'
    expect(page).to have_content 'find me!'
  end
end
