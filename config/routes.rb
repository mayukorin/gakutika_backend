Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create]
    post '/signin', to: 'sessions#create'
    get '/me', to: 'sessions#me'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
