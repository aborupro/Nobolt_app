Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
end
