# frozen_string_literal: true

module UserCreatable
  def manufacture_user(params)
    User.create(password: Devise.friendly_token[0, 20],
                email: params[:user][:email],
                first_name: params[:user][:first_name],
                last_name: params[:user][:last_name])
  end
end
