# frozen_string_literal: true

require 'spec_helper'

feature 'Workflow management' do
  scenario 'User visits new workflow partial' do
    visit '/workflows/new'
    expect(page).to have_content('New Workflow')
  end
end
