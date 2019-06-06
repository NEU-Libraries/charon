# frozen_string_literal: true

require 'rails_helper'

describe RolesController do
  let(:role) { create(:role) }

  describe 'edit' do
    render_views
    it 'renders the partial' do
      get :edit, params: { id: role.id }
      expect(response).to render_template('roles/edit')
    end
  end

  describe 'update' do
    it 'modifies the designation' do
      expect(role.designation).to eq Designation.user
      post :update, params: { id: role.id, designation: 'manager' }
      expect(role.reload.designation).to eq Designation.manager
    end
  end
end
