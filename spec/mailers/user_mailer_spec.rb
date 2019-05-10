# frozen_string_literal: true

describe UserMailer, type: :mailer do
  describe 'system_created_user_email' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.with(user: user).system_created_user_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('A Charon (http://charon.library.northeastern.edu) user account was created for you')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['notifications@charon.library.northeastern.edu'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("Welcome to charon.library.northeastern.edu, #{user.first_name}")
    end
  end
end
