Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :users, only: [:create]

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  resources :orders, only: [:new, :create, :index, :show, :update]

  namespace :merchant do
    root 'dashboard#index'

    resources :items, except: [:show]

    resources :coupons

    resources :orders, only: [:show]

    resources :item_orders, only: [:update]

    get '/profile', to: 'users#index'
  end

  namespace :admin do
    root 'dashboard#index'

    resources :users, only: [:show, :index]

    resources :merchants, only: [:show, :index, :update]

    get '/profile/:id', to: 'users#show'
    patch '/orders/:id', to: 'dashboard#update'
  end

  resources :coupon_sessions, only: [:create]

  scope :profile do
    resources :orders, only: [:create, :show, :index]
  end

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch '/cart/:item_id', to: 'cart#increment_decrement'

  get '/register', to: 'users#new'
  get '/profile', to: 'users#show'
  get '/profile/edit', to:'users#edit'
  patch '/profile/edit', to:'users#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/user/password/edit', to: 'users_password#edit'
  patch '/user/password/update', to: 'users_password#update'
end
