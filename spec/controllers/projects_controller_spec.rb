# frozen_string_literal: true

require 'rails_helper'

describe ProjectsController do
  describe 'new' do
    it 'renders the new record form' do
      get :new
      expect(response).to render_template('projects/new')
    end
  end

  describe "create" do
    context "with valid input" do
      it "creates a project" do
        post :create, params: { project: { title: 'Cat', description: 'In the hat' } }
        expect(assigns(:project).title).to eq('Cat')
      end
    end
  end
end
