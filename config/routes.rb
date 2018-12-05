Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
    
      post '/login', to: "users#login"
      post '/update_user_info', to: "users#update_user_info"
      
      # show posts at index page
      get 'posts/posts_by_recent', to: 'posts#posts_by_recent' # done
      get 'posts/posts_by_trend', to: 'posts#posts_by_trend'
      get 'posts/posts_by_category', to: 'posts#posts_by_category'
      get 'posts/posts_by_city', to: 'posts#posts_by_city' 
      get 'posts/posts_by_search', to: 'posts#posts_by_search'

      # create posts
      post 'users/:id/posts', to: 'posts#create'
      #acts_as_votable for vote function
      
      resources :posts do
        resources :comments
        member do 
          put "upvote", to: "posts#upvote"
          put "unvote", to: "posts#downvote"
        end
      end
      #acts_as taggable for tag function

      # show users' posts at profile page
      get 'posts/users_posts_by_recent', to: 'posts#users_posts_by_recent'
      get 'posts/users_posts_by_category', to: 'posts#users_posts_by_category'
      get 'posts/users_posts_by_city', to: 'posts#users_posts_by_city'
      get 'posts/users_posts_by_search', to: 'posts#users_posts_by_search'

      #update posts
      put 'users/:id/posts/:id', to: 'posts#update'

      #delete posts
      delete 'users/:id/posts/:id', to: 'posts#destroy'
      
      # edit user intro 
      post 'users/:id/intro', to: 'users#edit_intro'
      
    end
  end
end
  