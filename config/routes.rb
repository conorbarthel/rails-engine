Rails.application.routes.draw do
  #get '/api/v1/items/:item_id/merchant', to:'items_merchant#show'
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items do
        resources :merchant, controller: 'items_merchant', only: [:index]
      end
    end
  end
end
