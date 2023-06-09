Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_for :users
  root to: "pages#home"
  resources :travels do
    resources :step, only: [:index]
  end
  resources :activities, only: %i[update destroy]
  get "search", to: "pages#search"
  post "search", to: "pages#search_results"
  get "destinations", to: "pages#destinations"
  get "dashboard", to: "pages#dashboard"
  get "details", to: "travels#details"
end
