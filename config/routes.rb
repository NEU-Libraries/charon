# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]

  mount Blacklight::Engine => '/'
  # root to: "catalog#index"

  mount Minerva::Engine => '/minerva'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

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
  resources :projects
  resources :collections
  resources :system_collections

  root to: 'pages#home'

  # workflow
  get '/workflow/assign' => 'workflow#assign'
  get '/workflow/claim' => 'workflow#claim'
  get '/workflow/history/:id' => 'workflow#history'

  # dashboards
  get '/admin/dashboard' => 'admin#dashboard'
  get '/users/dashboard' => 'users#dashboard'

  # task dashboard
  get '/users/actions/:project_id', to: 'users#actions', as: 'actions'

  # admin
  get '/admin/new_user' => 'admin#new_user'
  post '/admin/create_user' => 'admin#create_user'

end
