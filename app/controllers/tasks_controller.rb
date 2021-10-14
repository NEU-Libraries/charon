# frozen_string_literal: true

class TasksController < ApplicationController
  include ModsDisplay::ControllerExtension

  before_action :user_check
  before_action :find_work, except: [:update_page]

  def catalog
    @mods_html = render_mods_display(@work).to_html

    catalog_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(@work.noid),
      interface_id: catalog_interface.id,
      status: Status.in_progress.name
    )

    raise StandardError, catalog_state.errors.full_messages unless catalog_state.save
  end

  def update_work
    change_set = WorkChangeSet.new(@work)
    change_set.a_member_of = @work.project.works_collection.id
    if change_set.validate(params[:work])
      change_set.sync
      saved_work = metadata_adapter.persister.save(resource: change_set.resource)
    end

    flash[:notice] = 'MODS updated'
    redirect_to work_path(saved_work)
  end

  def transcribe
    # Claim work
    assign_claimant
    stack = @work.stacks&.first
    return if stack.nil?

    page_array = stack.children.select { |c| c.instance_of?(Page) }
    @pages = Kaminari.paginate_array(page_array).page(params[:page]).per(1)
  end

  def update_page
    saved_page = update_text
    TeiService.new({ stack_id: saved_page.parent.noid }).run
    flash[:notice] = 'Updated page'
    redirect_back fallback_location: work_path(saved_page.parent.parent.noid)
  end

  def encode; end

  def review; end

  def publish; end

  def claim
    # get list of tasks from workflow
    # search work history for in progress and completed tasks
  end

  private

    def assign_claimant
      @work.claimant = current_user.id
      metadata_adapter.persister.save(resource: @work)
    end

    def find_work
      @work = Work.find(params[:id])
    end

    def update_text
      page = Page.find(params[:id])
      page.text = params[:page_text]
      page = metadata_adapter.persister.save(resource: page)
      log_text_update(page)
      page
    end

    def log_text_update(page)
      edit_state = Minerva::State.new(
        creator_id: minerva_user_id(current_user.id),
        work_id: minerva_work_id(page.parent.parent.noid),
        status: Status.edited.name
      )

      raise StandardError, edit_state.errors.full_messages unless edit_state.save
    end
end
