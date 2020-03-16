# frozen_string_literal: true

Rails.application.routes.draw do
  Healthcheck.routes(self)

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

  resources :generic_uploads, :path => 'uploads', except: [:index]
  resources :projects
  resources :collections
  resources :roles
  resources :workflows
  resources :works
  resources :interfaces

  root to: 'pages#home'

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
  # project uploads
  get '/projects/:id/uploads', to: 'projects#uploads', as: 'project_uploads'

  # mailboxer
  get '/notifications' => 'notifications#index'
  get '/inbox' => 'conversations#index'
  get '/notifications/:id/mark_as_read', to: 'notifications#mark_as_read', as: 'mark_notification_as_read'
  get '/notifications/mark_all_as_read', to: 'notifications#mark_all_as_read', as: 'mark_all_notifications_as_read'

  # uploads
  get '/uploads/:id/approve', to: 'generic_uploads#approve', as: 'upload_approve'
  get '/uploads/:id/attach/:workflow_id', to: 'generic_uploads#attach', as: 'upload_attach'
  get '/uploads/:id/deny', to: 'generic_uploads#deny', as: 'upload_deny'
  post '/uploads/:id/reject', to: 'generic_uploads#reject', as: 'upload_reject'

  # tasks
  get '/tasks/:id/claim', to: 'tasks#claim', as: 'claim_task'
  put '/tasks/:id/update', to: 'tasks#update_work', as: 'update_work'

  get '/tasks/:id/encode', to: 'tasks#encode', as: 'encode'
  get '/tasks/:id/catalog', to: 'tasks#catalog', as: 'catalog'
  get '/tasks/:id/publish', to: 'tasks#publish', as: 'publish'
  get '/tasks/:id/review', to: 'tasks#review', as: 'review'
  get '/tasks/:id/transcribe', to: 'tasks#transcribe', as: 'transcribe'

  # audit history
  get '/works/:id/history', to: 'works#history', as: 'history'
end
