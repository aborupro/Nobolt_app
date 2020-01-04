Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/gyms',    to: 'gyms#new'
  post   '/gyms',    to: 'gyms#create'
  post   '/gyms_search', to: 'gyms#search'
  post   '/gyms_choose', to: 'gyms#choose'
  get    '/records', to: 'records#new'
  post   '/records', to: 'records#create'
  post   '/records_search', to: 'records#search'
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
  resources :place, :only => [ :index, :show, :create, :destroy ]
end
