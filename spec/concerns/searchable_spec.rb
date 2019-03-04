# frozen_string_literal: true

require 'spec_helper'

describe Searchable do

  before do
    class FakesController < ApplicationController
      include Searchable
    end
  end
  after { Object.send :remove_const, :FakesController }
  let(:object) { FakesController.new }

  describe '#searchable' do
    it { expect(object.searchable).to be true }
  end
end
