# frozen_string_literal: true

require 'rails_helper'

describe User do
  let(:user) { create(:user) }
  let(:dev_user) { create(:dev) }
  let(:admin_user) { create(:admin) }

  describe '#dev?' do
    subject { dev_user.dev? }

    context 'returns true if user has that capacity' do
      it { is_expected.to be true }
    end

    it 'returns false if user does not have that capacity' do
      expect(admin_user.dev?).to be false
    end
  end

  describe '#admin?' do
    subject { admin_user.admin? }

    context 'returns true if user has that capacity' do
      it { is_expected.to be true }
    end

    it 'returns false if user does not have that capacity' do
      expect(dev_user.admin?).to be false
    end
  end

  describe 'capacity' do
    it 'default user should have capacity of user and not developer or administrator' do
      expect(user.capacity).to eq :user
    end
  end
end
