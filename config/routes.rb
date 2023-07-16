Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'students/activate_account', to: 'students#activate_account'
  resources :students
  resources :availabilities
end
