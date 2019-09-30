# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]

  mount Blacklight::Engine => '/'

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
  resources :roles
  resources :workflows

  root to: 'pages#home'

  # workflows
  get '/workflows/assign' => 'workflows#assign'
  get '/workflows/claim' => 'workflows#claim'
  get '/workflows/history/:id' => 'workflows#history'

  # dashboards
  get '/admin/dashboard' => 'admin#dashboard'
  get '/users/dashboard' => 'users#dashboard'

  # task dashboard
  get '/users/actions/:id', to: 'users#actions', as: 'actions'

  # admin
  get '/admin/new_user' => 'admin#new_user'
  post '/admin/create_user' => 'admin#create_user'

  # manager
  get '/users/new_user' => 'users#new_user'
  post '/users/create_user' => 'users#create_user'

  # project user registry
  get '/projects/:id/users', to: 'projects#users', as: 'project_users'
  get '/projects/:id/new_user', to: 'projects#new_user', as: 'project_new_user'
  get '/projects/:id/available_users', to: 'projects#available_users', as: 'project_available_users'
  get '/projects/:id/remove_user/:user_id', to: 'projects#remove_user', as: 'project_remove_user'
  post '/projects/:id/create_user', to: 'projects#create_user', as: 'project_create_user'
  post '/projects/:id/add_users', to: 'projects#add_users', as: 'project_add_users'
  # project workflows
  get '/projects/:id/workflows', to: 'projects#workflows', as: 'project_workflows'

  # mailboxer
  get '/notifications' => 'notifications#index'
  get '/inbox' => 'conversations#index'
  get '/notifications/:id/mark_as_read', to: 'notifications#mark_as_read', as: 'mark_notification_as_read'
  get '/notifications/mark_all_as_read', to: 'notifications#mark_all_as_read', as: 'mark_all_notifications_as_read'
end
