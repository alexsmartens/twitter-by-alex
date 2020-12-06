Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get '/help', :to => 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', :to => 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # "resources :resource" - automatically generate a full suite of RESTful routes
  resources :users do
    # "member" method adds additional routes to respond to URLs containing
    # the user id, eg. "/users/id/following" and "/users/id/followers"
    member do
      get :following, :followers
    end
    # "collection" method adds additional routes to respond to URLs without the
    # id, eg. "/users/tigers" as in the method below
    #     collection do
    #       get :tigers
    #     end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
