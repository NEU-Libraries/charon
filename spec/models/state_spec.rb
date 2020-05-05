# frozen_string_literal: true

require 'rails_helper'

describe State do
  let(:state) { create(:state) }

  describe 'claim_path' do
    it 'returns the route for the interface for this object' do
      Rails.application.routes.default_url_options[:host] = 'localhost:3000'
      expect(state.claim_path).to eq(Rails.application.routes.url_helpers.encode_url(Work.find(Minerva::Work.find(state.work_id).auid)))
    end
  end
end
