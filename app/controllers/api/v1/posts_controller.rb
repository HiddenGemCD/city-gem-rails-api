# app/controllers/api/v1/posts_controller.rb
class Api::V1::PostsController < Api::V1::BaseController
    before_action :set_post, only: [:show, :update, :destroy, :upvote, :unvote]
  
    def posts_by_recent
      @posts = Post.all.order(created_at: :desc)
  
      render json: {
       posts: @posts
      }
    end

    def posts_by_trend
    end

    def posts_by_category
    end

    def posts_by_city
    end

    def posts_by_search
    end

    def users_posts_by_recent
        @user_posts = Post.where(user_id: params[:id] )
        render json: {
          posts: @user_posts
        }
    end

    def users_posts_by_category
    end

    def users_posts_by_city
    end

    def users_posts_by_search
    end
  
    
   def update
     if @post.update(post_params)
    #    render :show
     else
       render_error
     end
   end
  
    def destroy
        @post.destroy
        head :no_content
    end
    
    def create
        @post = Post.new(post_params)
        @post.user_id = params[:id] if params[:id]
        @post.city_id = 1 # use city_id = 1 temporary
        # @post.avatar_url = User.find(params[:id]).avatar_url
        if @post.save
            render json: {}, status: :created
        else
            render_error
        end
    end

    def upvote
        @user = User.find(params[:user_id])
        @post.upvote_by @user
        # @post.save
        puts @post.votes_for.size
        render json: {}, status: :ok
    end
    
    def unvote
        @user = User.find(params[:user_id])
        @post.unvote_by @user
        # @post.save
        puts @post.votes_for.size
        render json: {}, status: :ok
    end
  
    private
    
    def set_post
    @post = Post.find(params[:id])
    end

    def post_params
    params.require(:post).permit(:name, :description, :user_id)
    end

    def render_error
    render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end

end