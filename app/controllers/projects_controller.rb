# frozen_string_literal: true

class ProjectsController < CatalogController
  include UserCreatable
  include Searchable
  include Sortable
  include ThumbnailHelper

  before_action :searchable, only: [:show]
  before_action :admin_check, only: %i[new create edit update]
  load_resource except: %i[new create]
  helper_method :sort_column, :sort_direction

  # Blacklight incantations
  blacklight_config.track_search_session = false
  layout 'application'

  configure_blacklight do |config|
    # CatalogController has a fq for hiding SystemCollections
    config.default_solr_params.delete(:fq)
  end

  def new
    @change_set = ProjectChangeSet.new(Project.new)
  end

  def create
    user_registry = UserRegistry.create
    change_set = ProjectChangeSet.new(Project.new(user_registry_id: user_registry.id))
    if change_set.validate(params[:project])
      change_set.sync
      @project = metadata_adapter.persister.save(resource: change_set.resource)
    end

    # After successfull creation of project, create system collections
    # and associate with the resource
    user_registry.project_id = @project.id
    user_registry.save!
    @project.generate_system_collections

    redirect_to project_path(@project)
  end

  def edit; end

  def update
    change_set = ProjectChangeSet.new(@project)
    if change_set.validate(params[:project])
      change_set.sync
      @project = metadata_adapter.persister.save(resource: change_set.resource)
    end

    make_thumbnail(@project, params[:project].permit(:binary))

    redirect_to project_path(@project)
  end

  def show
    authorize! :read, @project
    @response, @document_list = search_service.fetch(
      @project.filtered_children
    )
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
    redirect_to project_user_registry_path(@project)
  end

  def remove_user
    authorize! :oversee, @project
    user = User.find(params[:user_id])
    @project.remove_user(user)
    flash[:notice] = "Successfully removed #{user.first_name} #{user.last_name} from #{@project.title}."
    redirect_to project_user_registry_path(@project)
  end

  def user_registry
    authorize! :oversee, @project
    @roles = @project.roles.order("#{sort_column} #{sort_direction}")
  end

  def users
    params[:sort] = 'last_name' # Only value
    @users = @project.users.order("#{sort_column} #{sort_direction}")
  end

  def new_user
    authorize! :oversee, @project
    @user = User.new
    @create_user_path = project_create_user_path
    render 'shared/new_user'
  end

  def sign_up
    @user = User.new
    @create_user_path = project_create_user_path
    render 'shared/sign_up'
  end

  def create_user
    @user = manufacture_user(params)
    @project.attach_user(@user)
    UserMailer.with(user: @user).system_created_user_email.deliver_now
    flash[:notice] = "User successfully created and attached to #{@project.title}. "\
                     "Email sent to #{@user.email} for notification."
    redirect_to actions_path(@project)
  end

  def workflows
    @workflows = Workflow.where(project_id: Minerva::Project.where(auid: params[:id]).take&.id)
  end

  def uploads
    @uploads = GenericUpload.where(project_id: @project.noid)
  end

  def supplemental_uploads
    @generic_upload = GenericUpload.new
  end

  def create_supplemental_file; end

  def works; end
end
