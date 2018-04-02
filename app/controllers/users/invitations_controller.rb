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

    # Are they valid (basic regex)?

    # Loop and process
  end
end
