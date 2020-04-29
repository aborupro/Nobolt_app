Rails.application.routes.draw do
  root 'static_pages#home'
  get 'password_resets/new'
  get 'password_resets/edit'
  get    '/help',    to: 'static_pages#help'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/gyms_search',    to: 'gyms#search'
  post   '/gyms_search',    to: 'gyms#search'
  get    '/gyms_choose',    to: 'gyms#choose'
  post   '/gyms_choose',    to: 'gyms#choose'
  get    '/records_search', to: 'records#new'
  post   '/records_search', to: 'records#search'
  get    '/rankings'      , to: 'rankings#monthly'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :records,             only: [:index, :new, :create, :destroy]
  resources :gyms,                only: [:index, :new, :create, :destroy]
end
