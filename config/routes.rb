Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create]
    resources :gakutikas, only: [:index, :create]
    post '/update-tough-rank', to: 'gakutikas#update_tough_rank'
    post '/signin', to: 'sessions#create'
    get '/me', to: 'sessions#me'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
