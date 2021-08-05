# frozen_string_literal: true

require 'spec_helper'

describe Searchable do
  before do
    class FakesController < CatalogController
      include Searchable
    end
  end
  after { Object.send :remove_const, :FakesController }
  let(:object) { FakesController.new }

  describe '#searchable' do
    it 'is searchable' do
      object.searchable
      expect(object.instance_variable_get(:@searchable)).to be true
    end
  end
end
