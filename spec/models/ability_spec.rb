# frozen_string_literal: true

describe Ability do
  describe 'class methods' do
    it 'has keys for access control fields' do
      expect(described_class.read_group_field).to eq 'read_access_group_ssim'
      expect(described_class.read_user_field).to eq 'read_access_person_ssim'
      expect(described_class.discover_group_field).to eq 'read_access_group_ssim'
      expect(described_class.discover_user_field).to eq 'read_access_person_ssim'
      expect(described_class.download_group_field).to eq 'read_access_group_ssim'
      expect(described_class.download_user_field).to eq 'read_access_person_ssim'
    end
  end
end
