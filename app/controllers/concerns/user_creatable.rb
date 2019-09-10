# frozen_string_literal: true

module UserCreatable
  class UserError < StandardError; end
  extend ActiveSupport::Concern

  included do
    rescue_from UserError, with: :user_error
  end

  def manufacture_user(params)
    user = User.create(password: Devise.friendly_token[0, 20],
                       email: params[:user][:email],
                       first_name: params[:user][:first_name],
                       last_name: params[:user][:last_name])

    raise UserError, user.errors.full_messages.join('. ') if user.errors.full_messages.any?

    user
  end

  def user_error(exception)
    (flash[:error] = "Error creating user - #{exception}"
     redirect_to(root_path) && return)
  end
end
