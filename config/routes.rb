Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'
      delete 'logout', to: 'users#logout'
      resources :users, only: [:index] do
        collection do
          get 'search'
          delete 'delete_profile', to: 'users#delete_profile'
          put 'update_profile', to: 'users#update_profile'
        end
      end
      resources :menu_items, only: [:index, :create, :destroy] do
        collection do
          get 'menu_categories'
          get 'menu_items_by_category'
          get 'menu_item_by_id'
          post 'create_menu_category'
          put 'update_menu_category'
          delete 'delete_menu_category'
          get 'search_menu_items'
          get 'filter_menu_items'
        end
      end
      resources :orders, only: [:create, :index, :show] do
        member do
          patch 'update_status'
          patch 'assign_rider'
        end
      end
      resources :payments, only: [:create, :show, :update]
      resources :shop_details, only: [:show, :update]
    end
  end
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Catch-all for unmatched routes (must be last)
  match '*unmatched', to: 'application#route_not_found', via: :all
end
