class Users::InvitationsController < Devise::InvitationsController
  include Hydra::Controller::ControllerBehavior

  def mass_invitation
    # Are they logged in?
    if current_user.blank?
      http_error(403)
    end

    # Is there a pid, and is it an admin set?
    if params[:id].blank?
      http_error(400)
    else
      begin
        # Does the user have permissions?
        @admin_set = AdminSet.find(params[:id])
        authorize! :edit, @admin_set
      rescue CanCan::AccessDenied
        http_error(403)
      end
    end

    # Are there email addresses?
    if params[:emails].blank?
      http_error(400)
    end

    # Are they valid (basic regex)?
    emails = params[:emails].reject { |x| x.empty? }

    # regex from https://stackoverflow.com/questions/742451/what-is-the-simplest-regular-expression-to-validate-emails-to-not-accept-them-bl
    emails.each do |email_str|
      if !(/^[^@\s]+@[^@\s]+\.[^@\s]+$/.match?(email_str))
        http_error(400)
      end
    end

    # Loop and process
    emails.each do |email|
      # check if user exists
      if User.find_by_email(email).blank?
        User.invite!(:email => email)
      end

      # check if permissions exists
      begin
        # Add them as viewers of the admin set
        Hyrax::PermissionTemplateAccess.create!(permission_template: @admin_set.permission_template,
                                                    agent_type: 'user',
                                                    agent_id: email,
                                                    access: Hyrax::PermissionTemplateAccess::VIEW)
      rescue ActiveRecord::RecordInvalid
        # ActiveRecord::RecordInvalid (Validation failed: Access has already been taken)
        flash[:error] = "View permission already exists for - #{email}"
      end

    end

    flash[:notice] = "Mass Invitation of users sent."
    redirect_to hyrax.edit_admin_admin_set_path(params[:id])
  end
end
