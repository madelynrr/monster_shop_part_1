Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch '/cart/:item_id', to: 'cart#increment_decrement'

  resources :orders, only: [:new, :create, :index, :show, :update]

  post "/profile/orders", to: "orders#create"
  get '/profile/orders', to: 'orders#index'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile', to: 'users#show'

  get '/profile/edit', to:'users#edit'
  patch '/profile/edit', to:'users#update'
  get '/profile/orders/:id', to: 'orders#show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do
    root 'dashboard#index'
    get '/profile', to: 'users#index'
    patch '/item_orders/:id', to: 'item_orders#update'
    get '/orders/:id', to: 'orders#show'

    resources :items, except: [:show]

    resources :coupons
  end

  namespace :admin do
    root 'dashboard#index'
    resources :users, only: [:show, :index]
    resources :merchants, only: [:show, :index, :update]
    get '/profile/:id', to: 'users#show'
    patch '/orders/:id', to: 'dashboard#update'
  end

  get '/user/password/edit', to: 'users_password#edit'
  patch '/user/password/update', to: 'users_password#update'
  patch '/user/id', to: 'users#update'

  resources :coupon_sessions, only: [:create]



  # post '/coupon_sessions/update', to: 'coupon_sessions#update'
end
