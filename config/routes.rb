Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/items/find'
      get '/merchants/find_all'
      namespace :merchants do
        resources :most_items, only: [:index]
      end
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items do
        resources :merchant, controller: 'items_merchant', only: [:index]
      end
      resources :revenue, only: [:index] do
        resources :merchants, only: [:index, :show]
        resources :items, only: [:index, :show]
      end
    end
  end
end
