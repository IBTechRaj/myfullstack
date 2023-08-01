Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'students/activate_account', to: 'students#activate_account'
  get 'teachers/resend_email', to: 'teachers#resend_email'
  resources :students
  resources :teachers
  delete 'availabilities/delete_all', to: 'availabilities#delete_all'
  # put 'availabilities/updateTwo', to: 'availabilities#updateTwo'
  resources :availabilities
end
