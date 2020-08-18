# frozen_string_literal: true

require 'rails_helper'

describe WorksController do
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:admin_user) { create(:admin) }
  let(:blob) { FactoryBot.create_for_repository(:blob, :pdf) }

  describe 'assign_task' do
    it 'creates a new minerva task associated with interface and user' do
      # TODO: update this when the redirect properly integrates with dashboard
      sign_in admin_user
      create_interfaces
      post :assign_task, params: { id: work.id, task: 'transcribe', user: { id: admin_user.id } }
      expect(Minerva::State.count).to be 1
      expect(response).to redirect_to(project_works_path(work.project))
    end
  end

  describe 'tasks' do
    render_views
    it 'lists tasks that can be assigned' do
      # TODO: extend testing to verify users and tasks diplayed correlate with
      # work, workflow and project
      get :tasks, params: { id: work.noid }
      expect(response).to render_template('works/tasks')
      expect(CGI.unescapeHTML(response.body)).to include(work.title)
    end
  end

  describe 'show' do
    render_views
    it 'renders a works title' do
      LiberaJob.perform_now(work.noid, blob.noid)
      get :show, params: { id: work.noid }
      expect(response).to render_template('works/show')
      expect(CGI.unescapeHTML(response.body)).to include(work.title)
    end
  end

  describe 'history' do
    render_views
    it 'renders a list of actions taken for a work' do
      get :history, params: { id: work.noid }
      expect(response).to render_template('works/history')
    end
  end
end
