# frozen_string_literal: true

# Generated with `rails generate valkyrie:model Work`
require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work do
  let(:resource_klass) { described_class }
  let(:project) { FactoryBot.create_for_repository(:project) }
  it_behaves_like 'a Valkyrie::Resource'

  it 'has a helper method for finding the project it belongs to' do
    new_work = Valkyrie.config.metadata_adapter.persister.save(resource: Work.new(title: 'test work', project_id: project.id))
    expect(new_work.project).to eq project
  end
end
