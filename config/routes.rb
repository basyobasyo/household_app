Rails.application.routes.draw do
  devise_for :users
  resources :payments, only: :index
  root to: "payments#index"
end
