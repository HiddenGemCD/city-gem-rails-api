Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      # resources :posts, only: [:show]
      get 'posts/:id', to: 'posts#show'
      post '/login', to: "users#login"
      post '/update_user_info', to: "users#update_user_info"
      
      # all posts at index page
      get 'posts', to: 'posts#index' # done
      # get 'posts_by_trend', to: 'posts#trend'
      # get 'posts/posts_by_category', to: 'posts#posts_by_category'
      # get 'posts/posts_by_city', to: 'posts#posts_by_city' 
      # get 'posts/posts_by_search', to: 'posts#posts_by_search'

      # show specific post
      get 'posts/:id', to: 'posts#show'

      # create posts
      post 'users/:id/posts', to: 'posts#create'
      #acts_as_votable for vote function
      # put 'users/:user_id/posts/:id/upvote', to: 'posts#upvote'
      # put 'users/:user_id/posts/:id/unvote', to: 'posts#unvote'
      # get 'posts/:id/votes', to: 'posts#votes'

      # show users' posts at profile page
      # get 'users/:id/posts/by_recent', to: 'posts#users_posts_by_recent'
      # get 'posts/users_posts_by_category', to: 'posts#users_posts_by_category'
      # get 'posts/users_posts_by_city', to: 'posts#users_posts_by_city'
      # get 'posts/users_posts_by_search', to: 'posts#users_posts_by_search'

      #update posts
      put 'users/:id/posts/:id', to: 'posts#update'

      #delete posts
      delete 'posts/:id', to: 'posts#destroy'
      
      # edit user intro 
      post 'users/:id/intro', to: 'users#edit_intro'
    end
  end
end
  