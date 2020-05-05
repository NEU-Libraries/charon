# frozen_string_literal: true

describe State do
  let(:state) { create(:state) }

  describe 'present tense helper method' do
    it 'returns a string' do
      expect(interface.past_tense).to eq(I18n.t("charon.interface.#{interface.title}.past_tense"))
    end
  end

  describe 'past tense helper method' do
    it 'returns a string' do
      expect(interface.present_tense).to eq(I18n.t("charon.interface.#{interface.title}.present_tense"))
    end
  end
end
