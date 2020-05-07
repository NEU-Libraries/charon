# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StateHelper, type: :helper do
  describe '#claim_path' do
    let(:state) { create(:state) }

    it "returns the url for a state based on it's code point" do
      expect(helper.claim_path(state)).to eql("/tasks/#{Minerva::Work.find(state.work_id).auid}/encode")
    end
  end
end
