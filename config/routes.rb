Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, except: :index
      resource :session, only: %i[new create destroy]
      get 'users/:id/spotify/top/artists', to: 'spotify#grab_users_top_artists'
      get 'users/:id/spotify/recommendations/:genre', to: 'spotify#generate_recommendations'
      get '/auto', to: 'auth#auto_login'
    end
  end
end
