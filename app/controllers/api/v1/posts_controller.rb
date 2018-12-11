# app/controllers/api/v1/posts_controller.rb
class Api::V1::PostsController < Api::V1::BaseController
    before_action :set_post, only: [:show, :update, :destroy, :upvote, :unvote]

    CITIES = ['北京','上海','广州','深圳','武汉','西安','杭州','南京','成都','重庆','东莞','大连','沈阳','苏州','昆明','长沙','合肥','宁波','郑州','天津','青岛','济南','哈尔滨','长春','福州','香港','澳门']

    CITIES_EN = ['Beijing','Shanghai','Guangzhou','Shenzhen','Wuhan','Xi an','Hangzhou','Nanjing','Chengdu','Chongqing','Dongguan','Dalian','Shenyang','Suzhou','Kunming','Changsha','Hefei','Ningbo','Zhengzhou','Tianjin','Qingdao','Jinan','Harbin','Changchun','Fuzhou','Hong Kong','Macao']
  
    def index
        # show user's profile if user_id existed
        if params[:user_id]
            puts "profile: show user posts"
            @user = User.find(params[:user_id])
            @posts = @user.posts.order(created_at: :desc)
            if params[:city] || params[:category]
                @posts = filtered_posts(@posts)
            end
            
            @cities = @user.posts.all.map {|i| City.find(i.city_id).name}.uniq
            @cities << 'City'
        else
            # show trending index page if no user_id existed
            # should ordered by trending. How?
            puts "========================="
            puts "trending index page"
            puts params
            @posts = Post.all

            # if user trigger filter
            if params[:city] || params[:category]
                @posts = filtered_posts(@posts)
                puts "after filter"
                puts @posts
            end  

            @posts = trend(@posts)
            
            @cities = Post.all.map {|i| City.find(i.city_id).name}.uniq
        end        
    end

    def users_posts_by_recent
        puts params
        @user_posts = Post.where(user_id: params[:id] ).order(created_at: :desc)
        render json: {
          posts: @user_posts
        }
    end
  
    def show 
        puts @post
        render json: {
            shared_by: {name: @post.user.name, avatar: @post.user.avatar},
            post: @post,
            city: City.find(@post[:city_id])
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

        CITIES.each_with_index do |city, index|
            puts params[:address]
            # address to city 
            if post_params[:address].match(city)
                puts "city_cn..."
                puts city
                puts "translate to en..."
                puts CITIES_EN[index]
                @city = City.find_or_create_by(name: CITIES_EN[index])
                # @city = City.find_by(name: city)
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

    def filtered_posts(posts)
        puts "start filter"
        puts params

        @posts = posts

        if params[:city] == 'City' && params[:category] == 'All'
            puts "no filter"
            puts @posts
            return @posts
        end

        if params[:city] != 'City'
            puts "has city filter"
            @city = City.find_by(name: params[:city]) 
            puts @city
            puts @city.id
            @posts = @posts.where(city_id: @city.id)
        end

        if params[:category] && params[:category] != 'All'
            puts "has category filter"
            @posts.each {|post| puts post.category }
            @posts = @posts.where(category: params[:category].downcase)
            puts "after filtered with catgory....."
            @posts.each {|post| puts post.category }
        end

        return @posts
    end

    def trend(posts)
        puts "trending ordering"
        @posts = posts
        puts @posts
        address = @posts.map {|i| i.address}
        count = {}
        address.each do |i|
            if count[i]
                count[i] += 1
            else
                count[i] = 1
            end
        end
        count = count.sort_by{|k, v| v}.reverse.to_a
        count.map {|i| @posts.find_by( address: i[0])} 
    end
end