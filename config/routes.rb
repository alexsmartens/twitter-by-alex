Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  scope controller: :static_pages do
    get '/help' => :help
    get '/about' => :about
    get '/contact' => redirect("https://github.com/alexsmartens")
  end

  get '/signup', :to => 'users#new'

  scope controller: :sessions do
    get '/login' => :new
    post '/login' => :create
    delete '/logout' => :destroy
  end

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
  resources :reactions

  # Custom handling of common errors
   match "/404", to: "errors#not_found", via: :all
   match "/500", to: "errors#internal_server_error", via: :all
end
