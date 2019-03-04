# frozen_string_literal: true

require 'spec_helper'

describe SearchBarPresenter do
  let(:controller) { CatalogController.new }
  let(:presenter) { described_class.new(controller, blacklight_config) }
  let(:blacklight_config) { Blacklight::Configuration.new }

  describe '#autocomplete_enabled?' do
    subject { presenter.autocomplete_enabled? }

    describe 'with autocomplete config' do
      let(:blacklight_config) do
        Blacklight::Configuration.new.configure do |config|
          config.autocomplete_enabled = true
          config.autocomplete_path = 'suggest'
        end
      end

      it { is_expected.to be true }
    end

    describe 'without disabled config' do
      let(:blacklight_config) do
        Blacklight::Configuration.new.configure do |config|
          config.autocomplete_enabled = false
          config.autocomplete_path = 'suggest'
        end
      end

      it { is_expected.to be false }
    end

    describe 'without path config' do
      let(:blacklight_config) do
        Blacklight::Configuration.new.configure do |config|
          config.autocomplete_enabled = true
        end
      end

      it { is_expected.to be false }
    end
  end

  describe '#autofocus?' do
    subject { presenter.autofocus? }

    context 'has been disabled' do
      it { is_expected.to be false }
    end
  end

  describe '#render' do
    subject { presenter.render }

    context 'default is nil' do
      it { is_expected.to be nil }
    end

    context 'controller is a catalog, action is an index, and is set to searchable' do
      before do
        controller.request = ActionController::TestRequest.create(CatalogController)
        allow(controller).to receive(:action_name).and_return('index')
        controller.instance_variable_set(:@searchable, true)
      end
    end
  end
end
