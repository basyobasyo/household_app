Rails.application.routes.draw do
  resources :payments, only: :index
  root to: "payments#index"
end
