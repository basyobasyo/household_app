Rails.application.routes.draw do
  devise_for :users
  root to: 'payments#index'
  resources :payments do
    collection do
      post 'follow'
      get  'calculate_page'
      post 'calculate_result'
    end
      delete "unfollow", on: :member
  end
end
