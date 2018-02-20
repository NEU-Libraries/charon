class Users::MassInvitationsController < Devise::InvitationsController
  def create
    params[:user][:email].each do |email|
       User.invite!(:email => email)
    end
  end
end
