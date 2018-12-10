# app/controllers/api/v1/posts_controller.rb
class Api::V1::PostsController < Api::V1::BaseController
    before_action :set_post, only: [:show, :update, :destroy, :upvote, :unvote]

    CITIES = ['北京','上海','广州','深圳','武汉','西安','杭州','南京','成都','重庆','东莞','大连','沈阳','苏州','昆明','长沙','合肥','宁波','郑州','天津','青岛','济南','哈尔滨','长春','福州','广东省','江苏省','浙江省','四川省','海南省','福建省','山东省','江西省','广西','安徽省','河北省','河南省','湖北省','湖南省','陕西省','山西省','黑龙江省','辽宁省','吉林省','云南省','贵州省','甘肃省','内蒙古','宁夏','西藏','新疆','青海省','香港','澳门']
  
    def index
        # show user's profile if user_id existed

        puts params

        if params[:user_id]
            @user = User.find(params[:user_id])
            @posts = @user.posts.order(created_at: :desc)
            if params[:city] || params[:category]
                @posts = filtered_posts
            end

        else
            @posts = Post.all.order(created_at: :desc)

            if params[:city] || params[:category]
                @posts = filtered_posts
            end
            
            # # filtered by city
            # if params[:city]
            #     @city = City.find_by(name: params[:city]) 
            #     puts @city
            #     puts @city.id
            #     @posts = @posts.where(city_id: @city.id)
            # end
            # #filtered by category
            # if params[:category]
            #     @posts = @posts.where(category: params[:category])
            # end
        end 




    end

    def trend
        address = Post.all.map {|i| i.address}
        count = {}
        address.each do |i|
            if count[i]
                count[i] += 1
            else
                count[i] = 1
            end
        end
        count
    end

    def posts_by_category
    end

    def posts_by_city
    end

    def posts_by_search
    end

    def users_posts_by_recent
        puts params
        @user_posts = Post.where(user_id: params[:id] ).order(created_at: :desc)
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
  
    def show 
        puts @post
        render json: {
            post: @post
        }
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
        # puts CITIES
        puts post_params

        CITIES.each do |city|
            puts params[:address]
            # address to city 
            if post_params[:address].match(city)
                @city = City.find_by(name: city)
                @city.posts << @post if @city
                # puts @city.name
                @city.posts.each { |post| puts post }
            end
        end

        # tagstring to tags
        tags = post_params[:tagstring].split(',').map{ |i| i.strip }
        @post.tag_list.add(tags)
        if @post.save
            render json: {}, status: :created
        else
            render_error
        end
    end

    def upvote
        @user = User.find(params[:user_id])
        @post.upvote_by @user
        @post.votes += 1
        @post.save
        puts @post.name
        puts @post.votes_for.size
        render json: {}, status: :ok
    end
    
    def unvote
        @user = User.find(params[:user_id])
        @post.unvote_by @user
        @post.votes -= 1
        @post.save
        puts @post.name
        puts @post.votes_for.size
        render json: {}, status: :ok
    end

    # def tagged
    #     if params[:tag].present?
    #       @posts = Post.tagged_with(params[:tag])
    #     else
    #       @posts = Post.all
    #     end
    # end

    private
    
    def set_post
        @post = Post.find(params[:id])
    end

    def post_params
        params.require(:post).permit(:name, :description, :user_id, :address, :category, :latitude, :longitude, :tagstring )
    end

    def render_error
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end

    def filtered_posts
        if params[:city]
            @city = City.find_by(name: params[:city]) 
            puts @city
            puts @city.id
            @posts = @posts.where(city_id: @city.id)
        end
        #filtered by category
        if params[:category]
            @posts = @posts.where(category: params[:category])
        end
    end

end
