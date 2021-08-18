# frozen_string_literal: true

class ProjectsController < CatalogController
  include UserCreatable
  include Searchable
  include Sortable
  include ThumbnailHelper

  load_resource except: %i[new create]
  before_action :searchable, only: [:show]
  before_action :admin_check, only: %i[new create edit update]
  helper_method :sort_column, :sort_direction

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

    redirect_to actions_path(@project, new: true)
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

  def users
    params[:sort] = 'last_name' # Only value
    @users = @project.users.order("#{sort_column} #{sort_direction}")
  end

  def workflows
    @workflows = Workflow.where(project_id: Minerva::Project.where(auid: params[:id]).take&.id)
  end

  def uploads
    @uploads = GenericUpload.where(project_id: @project.noid)
  end

  def works; end

  private

    def oversee_check
      authorize! :oversee, @project
    end
end
