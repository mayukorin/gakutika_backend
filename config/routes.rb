Rails.application.routes.draw do
  
  namespace :api do
    resources :users, only: [:create]
    resources :gakutikas, only: [:index, :create, :show, :update, :destroy]
    resources :questions, only: [:create, :update, :destroy]
    resources :user_and_company_and_gakutikas, only: [:destroy, :create,]
    resources :user_and_companies, only: [:destroy, :update, :create, :index]
    post '/update-tough-rank', to: 'gakutikas#update_tough_rank'
    post '/signin', to: 'sessions#create'
    get '/me', to: 'sessions#me'
    namespace :gakutika do
      resources :search_by_title, only: [:index]
    end
    namespace :company do
      resources :search_by_name, only: [:index]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
