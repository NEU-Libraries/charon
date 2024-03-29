# frozen_string_literal: true

Rails.application.routes.draw do
  Healthcheck.routes(self)

  devise_for :users

  sidekiq_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && (current_user.admin? || current_user.developer?)
  end

  mount Blacklight::Engine => '/'

  constraints sidekiq_web_constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

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
  resources :notes
  resources :pages
  resources :comments

  root to: 'static#home'

  # mint id
  post '/mint_id' => 'application#mint_id', as: 'mint_id'

  # dashboards
  get '/admin/dashboard' => 'admin#dashboard'
  get '/users/dashboard' => 'users#dashboard'

  # task dashboard
  get '/users/actions/:id', to: 'users#actions', as: 'actions'

  # admin
  get '/admin/new_user' => 'admin#new_user'
  post '/admin/create_user' => 'admin#create_user'
  get '/admin/users', to: 'admin#users', as: 'admin_users'
  get '/admin/projects', to: 'admin#projects', as: 'admin_projects'
  post '/admin/delete_users' => 'admin#delete_users'

  # manager
  get '/users/new_user' => 'users#new_user'
  post '/users/create_user' => 'users#create_user'
  get '/users/upload' => 'users#upload', as: 'upload_users'
  post '/users/create_users' => 'users#create_users', as: 'create_users'

  # project user registry
  get '/projects/:id/user_registry', to: 'projects#user_registry', as: 'project_user_registry'
  post '/projects/:id/user_registry', to: 'projects#update_user_registry', as: 'update_user_registry'
  get '/projects/:id/users', to: 'projects#users', as: 'project_users'
  get '/projects/:id/new_user', to: 'projects#new_user', as: 'project_new_user'
  get '/projects/:id/sign_up', to: 'projects#sign_up', as: 'project_sign_up'
  get '/projects/:id/available_users', to: 'projects#available_users', as: 'project_available_users'
  get '/projects/:id/remove_user/:user_id', to: 'projects#remove_user', as: 'project_remove_user'
  post '/projects/:id/create_user', to: 'projects#create_user', as: 'project_create_user'
  post '/projects/:id/sign_up_user', to: 'projects#sign_up_user', as: 'project_sign_up_user'
  post '/projects/:id/add_users', to: 'projects#add_users', as: 'project_add_users'
  # project workflows
  get '/projects/:id/workflows', to: 'projects#workflows', as: 'project_workflows'
  # project uploads
  get '/projects/:id/uploads', to: 'projects#uploads', as: 'project_uploads'
  # all project works (no collection nesting)
  get '/projects/:id/works', to: 'projects#works', as: 'project_works'

  # system collections
  get '/projects/:id/supplemental_uploads', to: 'system_collections#supplemental_uploads', as: 'supplemental_uploads'
  post '/projects/:id/create_supplemental_file', to: 'system_collections#create_supplemental_file', as: 'create_supplemental_file'

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
  put '/tasks/:id/update_page', to: 'tasks#update_page', as: 'update_page'

  # works
  get '/works/:id/history', to: 'works#history', as: 'history'
  get '/works/:id/tasks', to: 'works#tasks', as: 'tasks'
  post '/works/:id/assign_task', to: 'works#assign_task', as: 'assign_task'

  # downloads
  get '/downloads/:id', to: 'downloads#download', as: 'download'

  # iiif manifest for file set
  get '/manifest/:id', to: 'images#manifest', as: 'manifest'
  get '/manifest/single/:id', to: 'images#single_manifest', as: 'single_manifest'

  resources :users, only: [:show, :edit, :update]
end
