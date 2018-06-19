require 'sidekiq/web'

Rails.application.routes.draw do

  jobs_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    (current_user.present? && current_user.ability.admin?)
  end

  constraints jobs_web_constraint do
    mount Sidekiq::Web => '/jobs'
  end

  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  mount Blacklight::Engine => '/'

    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, :controllers => { :invitations => 'users/invitations' }

  devise_scope :user do
    # get 'users/invitation/mass_invite' => 'users/invitations#mass_invite'
    post 'users/invitation/mass_invitation/:id' => 'users/invitations#mass_invitation', as: :mass_invitation
  end

  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :generic_uploads

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
