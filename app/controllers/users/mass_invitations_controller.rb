class Users::MassInvitationsController < Devise::InvitationsController
  def new
  end

  def create
    params[:user][:email].each do |email|
       User.invite!(:email => email)
    end
  end
end
