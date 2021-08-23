# frozen_string_literal: true

# Generated with `rails generate valkyrie:model Project`
require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Project do
  let(:resource_klass) { described_class }
  let(:user) { create(:user) }
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:managed_project) { FactoryBot.create_for_repository(:project) }
  let(:user_registry) { UserRegistry.find(project.user_registry_id) }
  it_behaves_like 'a Valkyrie::Resource'

  it 'has a find method that works with noid' do
    expect(described_class.find(project.noid)).to eq project
  end

  it 'has a find method that works with a full id' do
    expect(described_class.find(project.id)).to eq project
  end

  it 'returns nil retrieving the user registry if the id is not set' do
    expect(resource_klass.new.user_registry).to be nil
  end

  it 'is public by default' do
    expect(resource_klass.new.public?).to be true
  end

  it 'is not public if read groups don\'t include public value' do
    expect(resource_klass.new(read_groups: []).public?).to be false
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

  it 'removes a user' do
    project.user_registry.roles.delete_all
    project.attach_user(user)
    expect(project.user_registry.roles.first == user.roles.first).to be true
    project.remove_user(user)
    expect(project.user_registry.roles).to be_empty
  end

  it 'attaches a user and makes them a project manager' do
    managed_project.attach_user(user, Designation.manager)
    expect(managed_project.user_registry.roles.first.designation).to eq Designation.manager
    expect(managed_project.manager).to eq user
  end

  it 'returns roles' do
    expect(project.roles).to eq user_registry.roles
  end

  it 'returns users' do
    project.attach_user(user)
    expect(project.users).to include(user)
  end

  it 'returns workflows' do
    expect(project.workflows).to eq Workflow.where(project_id: Minerva::Project.where(auid: project.noid).take&.id)
  end
end
