# frozen_string_literal: true

require 'rails_helper'

describe User do
  let(:user) { create(:user) }
  let(:dev_user) { create(:dev) }
  let(:admin_user) { create(:admin) }
  let(:project) { FactoryBot.create_for_repository(:project) }

  describe '#developer?' do
    subject { dev_user.developer? }

    context 'returns true if user has that capacity' do
      it { is_expected.to be true }
    end

    it 'returns false if user does not have that capacity' do
      expect(admin_user.developer?).to be false
    end
  end

  describe '#admin?' do
    subject { admin_user.admin? }

    context 'returns true if user has that capacity' do
      it { is_expected.to be true }
    end

    it 'returns false if user does not have that capacity' do
      expect(user.admin?).to be false
    end
  end

  describe '#capacity' do
    it 'default user should have capacity of user and not developer or administrator' do
      expect(user.capacity).to eq :user
    end
  end

  describe '#role(project)' do
    it 'retrieves a users role from within a project' do
      project.attach_user(user)
      expect(user.role(project)).to eq user.roles.take
    end
  end

  describe '#designation(project)' do
    it 'retrieves a users designation from within a project' do
      project.attach_user(user)
      expect(user.designation(project)).to eq user.roles.take.designation
    end
  end
end
