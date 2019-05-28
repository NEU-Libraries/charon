# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def system_created_user_email
    @user = params[:user]
    @token, enc = Devise.token_generator.generate(User, :reset_password_token)

    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(validate: false)

    mail(to: @user.email, subject: 'A Charon (http://charon.library.northeastern.edu) user account was created for you')
  end
end
