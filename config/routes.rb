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

  root to: "pages#home"
end
