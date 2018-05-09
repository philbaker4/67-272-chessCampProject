Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  get 'dashboards/show', to: 'dashboards#show', as: :dashboard

  root 'dashboards#show'

  # Routes for main resources
  resources :camps
  resources :instructors
  resources :locations
  resources :curriculums
  resources :families
  resources :students
  resources :users
  resources :sessions
  
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout
  get 'new_fam_login', to: 'sessions#create', as: :new_fam_login


  # Routes for managing camp instructors
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor



  resources :registrations


  # cart stuff
  get "view_cart" => "home#view_cart", as: :view_cart
  post "camps/add_to_cart/:id", to: "camps#add_to_cart", as: :add_to_cart
  post "camps/remove_one_from_cart/:id", to: "camps#remove_one_from_cart", as: :remove_one_from_cart
  post "camps/delete_from_cart/:id", to: "camps#delete_from_cart", as: :delete_from_cart


end
 