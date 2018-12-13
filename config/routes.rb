Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
    
      # create
      post '/login', to: "users#login"
      post '/update_user_info', to: "users#update_user_info"
      post 'users/:id/posts', to: 'posts#create'

      # read
      get 'posts', to: 'posts#index'
      get 'posts/:id', to: 'posts#show'
      get 'get_current_city', to: 'posts#get_current_city'

      # update
      put 'users/:id/posts/:id', to: 'posts#update'

      # delete
      delete 'posts/:id', to: 'posts#destroy'
          
    end
  end
end
  