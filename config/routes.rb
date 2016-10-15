Rails.application.routes.draw do
  root "welcome#index"
  resources :flights
  resources :bookings
  resources :airports
  resources :users
  get "about" => "welcome#about"
  get "login" => "sessions#login"
  post "attempt_login" => "sessions#attempt_login"
  get "logout" => "sessions#logout"
  get "past_bookings" => "manage_booking#past"
  get "search_booking" => "manage_booking#search"
end
