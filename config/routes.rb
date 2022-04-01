Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/items/find'
      get '/merchants/find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items do
        resources :merchant, controller: 'items_merchant', only: [:index]
      end
    end
  end
end
