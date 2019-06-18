# frozen_string_literal: true

class ProjectsController < CatalogController
  include UserCreatable
  helper_method :sort_column, :sort_direction

  before_action :admin_check, only: %i[new create edit update]
  load_resource except: %i[new create edit update]

  # Blacklight incantations
  blacklight_config.track_search_session = false
  layout 'application'

  def new
    @change_set = ProjectChangeSet.new(Project.new)
  end

  def create
    change_set = ProjectChangeSet.new(Project.new(user_registry_id: UserRegistry.create.id))
    if change_set.validate(params[:project])
      change_set.sync
      @project = metadata_adapter.persister.save(resource: change_set.resource)
    end

    # After successfull creation of project, create system collections
    # and associate with the resource
    @project.generate_system_collections

    redirect_to project_path(@project)
  end

  def edit; end

  def update; end

  def show
    authorize! :read, @project
    @response, @document_list = search_service.fetch(["29d27047-50a0-4a58-ba77-1e776385f86c", "05f6e402-1a11-43be-bf83-61c010704c5b"])
  end

  def available_users
    authorize! :oversee, @project
    # Need to filter down to users not already attached to project
    already_attached_users = @project.users
    @users = User.all.reject { |u| already_attached_users.include? u }
  end

  def add_users
    authorize! :oversee, @project
    user_ids = params[:user_ids]
    user_ids.each do |id|
      @project.attach_user(User.find(id))
    end
    flash[:notice] = "Successfully added users to #{@project.title}."
    redirect_to project_users_path(@project)
  end

  def remove_user
    authorize! :oversee, @project
    user = User.find(params[:user_id])
    @project.remove_user(user)
    flash[:notice] = "Successfully removed #{user.first_name} #{user.last_name} from #{@project.title}."
    redirect_to project_users_path(@project)
  end

  def users
    authorize! :oversee, @project
    @roles = @project.roles.order(sort_column + ' ' + sort_direction)
  end

  def new_user
    authorize! :oversee, @project
    @user = User.new
    @create_user_path = project_create_user_path
    render 'shared/new_user'
  end

  def create_user
    authorize! :oversee, @project
    @user = manufacture_user(params)
    @project.attach_user(@user)

    UserMailer.with(user: @user).system_created_user_email.deliver_now
    flash[:notice] = "User successfully created and attached to #{@project.title}."\
                     "Email sent to #{@user.email} for notification."
    redirect_to actions_path(@project)
  end

  private

    def sort_column
      return 'designation' unless params[:sort]

      (User.column_names + Role.column_names).include?(params[:sort].split('.').last) ? params[:sort] : 'designation'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
