class Users::InvitationsController < Devise::InvitationsController
  def mass_invitation
    # Are they logged in?
    if !current_user.blank?

    # Is there a pid, and is it an admin set?

    # Does the user have permissions?

    # Are there email addresses?

    # Are they valid (basic regex)?

    # Loop and process
  else # must be logged in to mass invite
      render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false and return
    end
  end
end
