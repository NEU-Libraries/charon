# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Comment do
  let(:resource_klass) { described_class }
  # let(:blob) { FactoryBot.create_for_repository(:blob) }
  it_behaves_like 'a Valkyrie::Resource'
end
