# frozen_string_literal: true

# Generated with `rails generate valkyrie:model Project`
require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Project do
  let(:resource_klass) { described_class }
  let(:user) { create(:user) }
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:managed_project) { FactoryBot.create_for_repository(:project) }
  let(:user_registry) { UserRegistry.find(project.user_registry_id) }
  it_behaves_like 'a Valkyrie::Resource'

  it 'raises an error retrieving the user registry if the id is not set' do
    expect { resource_klass.new.user_registry }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'provides the user registry' do
    expect(project.user_registry == user_registry)
  end

  it 'attaches a user' do
    project.attach_user(user)
    # expect that project has a user registry
    # which has the same role as the user
    expect(project.user_registry.roles.first == user.roles.first).to be true
  end

  it 'attaches a user and makes them a project manager' do
    managed_project.attach_user(user, true)
    expect(managed_project.user_registry.roles.first.designation).to eq Designation.manager
  end

  it 'returns roles' do
    expect(project.roles).to eq user_registry.roles
  end

  it 'returns users' do
    project.attach_user(user)
    expect(project.users).to include(user)
  end
end
