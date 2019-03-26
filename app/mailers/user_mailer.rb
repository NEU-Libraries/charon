# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def admin_created_user_email
    @user = params[:user]
    _, @token = Devise.token_generator.generate(User, :reset_password_token)

    @user.reset_password_token = @token
    @user.reset_password_sent_at = Time.now.utc

    mail(to: @user.email, subject: 'A Charon (http://charon.library.northeastern.edu) user account was created for you')
  end
end
