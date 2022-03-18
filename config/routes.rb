Rails.application.routes.draw do
  
  namespace :api do
    resources :users, only: [:create]
    resources :gakutikas, only: [:index, :create, :show, :update, :destroy]
    resources :questions, only: [:create, :update, :destroy]
    resources :companies, only: [:index]
    resources :user_and_company_and_gakutikas, only: [:destroy, :create,]
    resources :user_and_companies, only: [:destroy, :update, :create, :index]
    get '/search-company/:name', to: 'companies#search'
    post '/update-tough-rank', to: 'gakutikas#update_tough_rank'
    post '/signin', to: 'sessions#create'
    get '/me', to: 'sessions#me'
    get '/search-gakutika-by-title', to: '#index'
    namespace :gakutika do
      resources :search_by_title, only: [:index]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
