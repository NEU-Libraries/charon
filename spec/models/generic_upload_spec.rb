# frozen_string_literal: true

describe GenericUpload do
  describe 'ActiveStorage attachment' do
    let(:gu) { described_class.new }
    it 'has_one_attached' do
      expect(gu.class).to be GenericUpload
    end
  end
end
