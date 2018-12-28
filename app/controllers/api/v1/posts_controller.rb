require 'open-uri'
require 'json'

class Api::V1::PostsController < Api::V1::BaseController
    before_action :set_post, only: [:show, :update, :destroy, :upvote, :unvote]
    
    CITIES2EN = {
        '北京' => 'Beijing',
        '上海' => 'Shanghai',
        '广州' => 'Guangzhou',
        '深圳' => 'Shenzhen',
        '武汉' => 'Wuhan',
        '西安' => 'Xi an',
        '杭州' => 'Hangzhou',
        '南京' => 'Nanjing',
        '成都' => 'Chengdu',
        '重庆' => 'Chongqing',
        '东莞' => 'Dongguan',
        '大连' => 'Dalian',
        '沈阳' => 'Shenyang',
        '苏州' => 'Suzhou',
        '昆明' => 'Kunming',
        '长沙' => 'Changsha',
        '合肥' => 'Hefei',
        '宁波' => 'Ningbo',
        '郑州' => 'Zhengzhou',
        '天津' => 'Tianjin',
        '青岛' => 'Qingdao',
        '济南' => 'Jinan',
        '哈尔滨' => 'Harbin',
        '长春' => 'Changchun',
        '福州' => 'Fuzhou',
        '香港' => 'Hong Kong',
        '澳门' => 'Macao',
        '台北' => 'Taipei',
        '高雄' => 'Kaohsiung',
        '宜兰' => 'Yilan',
        '桃园' => 'Taoyuan',
        '新竹' => 'Hsinchu',
        '苗栗' => 'Miaoli',
        '台中' => 'Taichung',
        '彰化' => 'Changhua',
        '南投' => 'Nantou',
        '云林' => 'Yunlin',
        '嘉义' => 'Chiayi',
        '台南' => 'Tainan',
        '屏东' => 'Pingtung',
        '台东' => 'Taitung',
        '花莲' => 'Hualien',
        '澎湖' => 'Penghu',
        '基隆' => 'Keelung',
        '連江' => 'Lienchiang',
        '金門' => 'Kinmen'
    }

    def index
        # show user's profile if user_id existed
        if params[:user_id]
            @user = User.find(params[:user_id])
            @posts = @user.posts.order(created_at: :desc)
            puts @posts
            
            if params[:city] || params[:category]
                @posts = filtered_posts(@posts)
                puts @posts
            end
            
            @cities = @user.posts.all.map {|i| City.find(i.city_id).name}.uniq
            @cities = @cities.reverse
        else
            @posts = Post.all
            # if user trigger filter
            if params[:city] || params[:category]
                @posts = filtered_posts(@posts)
            end  
            count = trend(@posts)
            @trending_posts = count.map {|i| @posts.find_by( address: i[0])} 
            @trending_counts = count.map {|i| i[1]} 
            @cities = City.all.select { |city| city.posts.size > 0 }.map {|i| i.name}
            @cities << 'All Cities'
        end        
    end

    def show 
        puts @post
        render json: {
            shared_by: { 
                name: @post.user.name, 
                avatar: @post.user.avatar
            },
            post: @post,
            city: City.find(@post[:city_id])
        }
    end
    
    def update
        if @post.update(post_params)
            @post.tagstring = post_params[:tagstring]
            tags = post_params[:tagstring].split(',').map{ |i| i.strip }
            @post.tag_list = ""
            @post.tag_list.add(tags)
            @post.save
        else
            render_error
        end
    end
  
    def destroy
        @post.destroy
        head :no_content
    end
    
    def create

        puts "create new post..."

        @post = Post.new(post_params)
        @post.category = post_params[:category]
        @post.user_id = params[:id] if params[:id]

        @city = City.find_or_create_by(name: params[:city])
        @city.posts << @post if @city

        
        # matched = false
        # CITIES2EN.each do |key, value|
        #     puts key
        #     puts value
        #     # address to city 
        #     if params[:city].match(key)
        #         @city = City.find_or_create_by(name: value)
        #         @city.posts << @post if @city
        #         matched = true
        #     end
        # end

        # if !matched
        #     url = 'http://fy.iciba.com/ajax.php?a=fy&f=zh&t=en&w=' + params[:city]
        #     url = URI.parse(URI.escape(url))

        #     puts url
        #     response = open(url).read
        #     data = JSON.parse(response)

        #     puts data
        #     city = data['content']['out']
        #     city.slice!('[地名] [中国]')
        #     city.slice!('City')
        #     city.slice!('Province')
        #     city = city.strip
        #     @city = City.find_or_create_by(name: city)
        #     @city.posts << @post if @city
        #     @city = City.find_or_create_by(name: city)
        #     @city.posts << @post if @city
        # end
        

        # tagstring to tags
        tags = post_params[:tagstring].split(',').map{ |i| i.strip }
        @post.tag_list.add(tags)

        if @post.save
            render json: {}, status: :created
        else
            render_error
        end
    end

    def get_current_city
        puts "get current city......"
        puts params[:current_city]

        input_city = params[:current_city]
        city_lang = lang_validation(input_city)

        puts "#{city_lang}"

        if city_lang == 'en'
            @city = input_city

        else
            @city = city_to_en(input_city)
            
        end

        render json: {
            current_city: @city
        }

        City.find_or_create_by(name: @city)

        # matched = false
        # CITIES2EN.each do |key, value|
        #     if params[:current_city].match(key)
        #         current_city = CITIES2EN[key]
        #         City.find_or_create_by(name: current_city)
        #         matched = true
        #         render json: {
        #             current_city: current_city
        #         }
        #     end
        # end

        # if !matched
        #     url = 'http://fy.iciba.com/ajax.php?a=fy&f=zh&t=en&w=' + params[:current_city]
        #     url = URI.parse(URI.escape(url))
        #     puts url
        #     response = open(url).read
        #     data = JSON.parse(response)
        #     puts data
        #     city = data['content']['out']
        #     city.slice!('[地名] [中国]')
        #     city.slice!('City')
        #     city.slice!('Province')
        #     city = city.strip

        #     render json: {
        #         current_city: city
        #     }
        # end

        
    end

    def lang_validation(city)
        city = city.scan(/\w*/).join(" ")
        if city.empty? || city.strip == ""
            puts "#{city} is Chinese..."
            return 'zh'
        else
            puts "#{city} is English ..."
            return 'en'
        end
    end

    def city_to_en(city)
        
        matched = false
     
        CITIES2EN.each do |key, value|
            if city.match(key)
                city = CITIES2EN[key]
                matched = true
                return city
            end
        end

        if !matched
            url = 'http://fy.iciba.com/ajax.php?a=fy&f=zh&t=en&w=' + city
            url = URI.parse(URI.escape(url))
            puts url
            response = open(url).read
            data = JSON.parse(response)
            puts data
            city = data['content']['out']
            city.slice!('[地名] [中国]')
            city.slice!('City')
            city.slice!('Province')
            city = city.strip
            return city
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

        category = params[:category]
        city = params[:city]
        @posts = posts

        # by default, show all
        if (category == '' || category == 'All Categories') && (city == '' || city == 'All Cities' || city == 'All')
            puts "no filter"
            puts @posts
            return @posts
        end

        if city != '' && city != 'All Cities' && city != 'All'
            puts "has city filter"
            @city = City.find_by(name: city) 
            puts @city
            puts @city.id
            @posts = @posts.where(city_id: @city.id)
        end

        if  category != '' && category != 'All Categories' 
            puts "has category filter"
            @posts.each {|post| puts post.category }
            @posts = @posts.where(category: params[:category])
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
    end
end
