class Users::InvitationsController < Devise::InvitationsController
  def mass_invitation
    # Are they logged in?

    # Is there a pid, and is it an admin set?

    # Does the user have permissions?

    # Are there email addresses?

    # Are they valid (basic regex)?

    # Loop and process
  end
end
