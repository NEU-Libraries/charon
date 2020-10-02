# frozen_string_literal: true

class TasksController < ApplicationController
  include ModsDisplay::ControllerExtension

  before_action :find_work, except: [:update_page]

  def catalog
    @mods_html = render_mods_display(@work).to_html

    catalog_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(@work.noid),
      interface_id: catalog_interface.id,
      status: Status.in_progress.name
    )

    raise StandardError, state.errors.full_messages unless catalog_state.save
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
    stack = @work.stacks&.first
    return if stack.nil?

    page_array = stack.children.select { |c| c.class == Page }
    @pages = Kaminari.paginate_array(page_array).page(params[:page]).per(1)
  end

  def update_page
    page = Page.find(params[:id])
    page.text = params[:page_text]
    saved_page = metadata_adapter.persister.save(resource: page)

    flash[:notice] = "Updated page"
    redirect_to work_path(saved_page.parent.parent.noid)
  end

  def encode; end

  def review; end

  def publish; end

  def claim
    # get list of tasks from workflow
    # search work history for in progress and completed tasks
  end

  private

    def find_work
      @work = Work.find(params[:id])
    end
end
