Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get 'account_block/teachers/activate_account', to: 'account_block/teachers#activate_account'
  get 'account_block/students/activate_account', to: 'account_block/students#activate_account'
  get 'account_block/teachers/resend_email', to: 'account_block/teachers#resend_email'
  get 'account_block/students/resend_email', to: 'account_block/students#resend_email'
  put 'account_block/teachers/deactivate_account', to: 'account_block/teachers#deactivate_account'
  put 'account_block/students/deactivate_account', to: 'account_block/students#deactivate_account'
  get 'account_block/teachers/send_names', to: 'account_block/teachers#send_names'
  get 'account_block/students/send_names', to: 'account_block/students#send_names'
  get 'account_block/students/student_view', to: 'account_block/students#student_view'
  get 'account_block/teachers/teacher_profile', to: 'account_block/teachers#teacher_profile'
  put 'account_block/teachers/set_display_language', to: 'account_block/teachers#set_display_language'
  put 'account_block/students/set_display_language', to: 'account_block/students#set_display_language'
  
  get 'account_block/teachers/get_notifications', to: 'account_block/teachers#get_notifications'
  put 'account_block/teachers/set_notifications', to: 'account_block/teachers#set_notifications'
  get 'account_block/teachers/get_timezone_date_time_formats', to: 'account_block/teachers#get_timezone_date_time_formats'
  put 'account_block/teachers/set_timezone_date_time_formats', to: 'account_block/teachers#set_timezone_date_time_formats'
  get 'account_block/students/get_notifications', to: 'account_block/students#get_notifications'
  put 'account_block/students/set_notifications', to: 'account_block/students#set_notifications'
  get 'account_block/students/get_timezone_date_time_formats', to: 'account_block/students#get_timezone_date_time_formats'
  put 'account_block/students/set_timezone_date_time_formats', to: 'account_block/students#set_timezone_date_time_formats'
  
   get 'account_block/invitee_teachers/activate_account', to: 'account_block/invitee_teachers#activate_account'
  get 'account_block/invitee_students/activate_account', to: 'account_block/invitee_students#activate_account'
   get 'account_block/invitee_teachers/invitee_teacher_names', to: 'account_block/invitee_teachers#invitee_teacher_names'
  get 'account_block/invitee_students/invitee_student_names', to: 'account_block/invitee_students#invitee_student_names'

  namespace :bx_block_notifications do
    get 'canceled_class', to: 'teacher_notifications#canceled_class'
    get 'class_availability', to: 'teacher_notifications#class_availability'
    get 'class_reminder', to: 'teacher_notifications#class_reminder'
    get 'ending_group_course', to: 'teacher_notifications#ending_group_course'
    get 'group_class', to: 'teacher_notifications#group_class'
    get 'new_class', to: 'teacher_notifications#new_class'

    get 'student_canceled_class', to: 'student_notifications#student_canceled_class'
    get 'student_booked_class_confirmation', to: 'student_notifications#student_booked_class_confirmation'
    get 'student_class_changes', to: 'student_notifications#student_class_changes'
    get 'student_class_reminder', to: 'student_notifications#student_class_reminder'
    get 'student_membership', to: 'student_notifications#student_membership'
  end
  namespace :account_block do
    post 'teacher_forgot_password', to: 'teacher_password_resets#forgot'
    post 'teacher_reset_password', to: 'teacher_password_resets#reset'
    post 'student_forgot_password', to: 'student_password_resets#forgot'
    post 'student_reset_password', to: 'student_password_resets#reset'
    resources :accounts, only: %i(create update) do
    end
	  resources :teachers,  only: %i(create update show index edit) do
    end
    resources :language_courses
    get 'get_test', to: 'assessments#get_test'
    resources :assessments
    resources :assessment_questions
    resources :assessment_options
    resources :language121_classes
    
    # resources :invitee_teachers do
    #   get 'activate_account', to: 'invitee_teachers#activate_account'
    #   get 'invitee_teacher_names', to: 'invitee_teachers#invitee_teacher_names'
    # end
    resources :invitee_students do
      get 'activate_account', to: 'invitee_teachers#activate_account'
      get 'invitee_student_names', to: 'invitee_teachers#invitee_student_names'
    end
	  resources :students, only: %i(create update show index edit) do
    end
    
  end
  namespace :bx_block_login do
    resources :teachers
    resources :students
  end
  namespace :bx_block_password do
    put 'teacher_change_password', to: 'teacher_passwords#change_password'
    put 'student_change_password', to: 'student_passwords#change_password'
  end
  namespace :bx_block_classes do
    resources :language_classes
    # resources :language121_classes
  end
  namespace :bx_block_custom_user_subs do
    resources :subscription_plans
    resources :study_formats
    resources :language_type
  end
  namespace :bx_block_landingpage3 do
    resources :language
    resources :frequently_asked_questions
  end
  namespace :bx_block_appointment_management do
    post 'set_availability', to: 'availabilities#create'
    get 'show_availability', to: 'availabilities#show'
    delete 'delete_all', to: 'availabilities#delete_all'
    # delete 'delete_oneday', to: 'availabilities#delete_oneday'
    resources :availabilities
  end
end

