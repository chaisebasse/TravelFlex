Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_for :users
  root to: "pages#home"

<<<<<<< HEAD
  resources :travel
  resources :activity, only: %i[update destroy]
  get "dashboard", to: "pages#dashboard"
=======
  resources :travels
  resources :activities, only: %i[update destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
>>>>>>> master
end
