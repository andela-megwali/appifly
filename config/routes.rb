Rails.application.routes.draw do
  root "welcome#index"
  resources :flights
  resources :bookings
  resources :airports
  resources :users
  get "about" => "welcome#about"
  get "login" => "users#login"
  post "attempt_login" => "users#attempt_login"
  get "logout" => "users#logout"
  get "past_bookings" => "bookings#past"
  get "search_booking" => "bookings#search_booking"
end
