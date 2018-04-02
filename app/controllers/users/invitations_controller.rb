class Users::InvitationsController < Devise::InvitationsController
  def mass_invitation
    # Are they logged in?
    if current_user.blank?
      render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false and return
    end

    # Is there a pid, and is it an admin set?
    if params[:id].blank?
      render :file => "#{Rails.root}/public/400.html", :status => 400, :layout => false and return
    else
      begin
        # Does the user have permissions?
        @admin_set = AdminSet.find(params[:id])
        authorize! :edit, @admin_set
      rescue CanCan::AccessDenied
        render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false and return
      end
    end

    # Are there email addresses?
    if params[:emails].blank?
      render :file => "#{Rails.root}/public/400.html", :status => 400, :layout => false and return
    end

    # Are they valid (basic regex)?
    emails = params[:emails]

    # regex from https://stackoverflow.com/questions/742451/what-is-the-simplest-regular-expression-to-validate-emails-to-not-accept-them-bl
    emails.each do |email_str|
      if !(/^[^@\s]+@[^@\s]+\.[^@\s]+$/.match?(email_str))
        # Raise custom error and flash to tell the user their input was bad
        render :file => "#{Rails.root}/public/400.html", :status => 400, :layout => false and return
      end
    end

    # Loop and process
    emails.each do |email|
      User.invite!(:email => email)
    end
  end
end
