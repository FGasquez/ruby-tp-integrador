Rails.application.routes.draw do
  root to: 'home#index'
  resources :appointments
  resources :professionals
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]
  get '/login', to: 'sessions#new', as: :log_in
  delete '/logout', to: 'sessions#destroy', as: :log_out
  resources :users, only: [:new, :create]
  get '/signup', to: 'users#new', as: :sign_up
  get '/professional/:id/appointments', to: 'professionals#appointments', as: :professional_appointments
  get '/professional/:id/cancel_all', to: 'professionals#destroy_all_appointments', as: :cancel_all
end
