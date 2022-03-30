Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items, only: [:index, :show]
    end
  end
end
