Rails.application.routes.draw do
  root 'static_pages#home'
  get '/score', to: 'static_pages#score'
  get 'password_resets/new'
  get 'password_resets/edit'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/gyms_search',    to: 'gyms#search'
  post   '/gyms_search',    to: 'gyms#search'
  get    '/gyms_choose',    to: 'gyms#choose'
  post   '/gyms_choose',    to: 'gyms#choose'
  get    '/rankings', to: 'records#rank'
  get    '/graphs', to: 'records#graph'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: %i[new create edit update]
  resources :relationships,       only: %i[create destroy]
  resources :records,             only: %i[index new create destroy] do
    resources :likes, only: %i[create destroy]
  end
  resources :gyms, only: %i[index new create update destroy]
  get '/gyms/:id', to: 'gyms#edit', as: 'edit_gym'
end
