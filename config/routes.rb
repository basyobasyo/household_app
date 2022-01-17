Rails.application.routes.draw do
  devise_for :users
  root to: "payments#index"
  resources :payments do
    collection do
      post 'follow'
    end
  end
end
