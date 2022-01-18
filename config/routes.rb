Rails.application.routes.draw do
  devise_for :users
  root to: "payments#index"
  resources :payments do
    collection do
      post 'follow'
      get  'calculate_page'
      get  'calculate_result'
    end
  end
end
