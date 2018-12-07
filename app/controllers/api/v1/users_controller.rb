class Api::V1::UsersController < Api::V1::BaseController
    skip_before_action :verify_authenticity_token
    
    URL = "https://api.weixin.qq.com/sns/jscode2session".freeze 

    def wechat_params
        { appid: ENV['APPID'],
          secret: ENV['SECRET'],
          js_code: params[:code], 
          grant_type: "authorization_code" }
        # { appid: 'wx6a983385b6475bf3',
        #   secret: '07c66cb4dccd74a7c4830197189b748a',
        #   js_code: params[:code], 
        #   grant_type: "authorization_code" }
    end

    def wechat_user        
        @wechat_response ||= RestClient.post( URL, wechat_params ) 
        @wechat_user ||= JSON.parse(@wechat_response.body)
    end

    def login        
        @user = User.find_or_create_by(open_id: wechat_user['openid'])
        render json: { userId: @user}
    end

    def update_user_info
        puts "update user info"
        @user = User.find(params[:id])
        @user.name = params[:name]
        @user.city = params[:city]
        @user.gender = params[:gender]
        @user.avatar = params[:avatar]
        @user.save
    end

    def index
      @users = User.all
      render json: {
        users: @users
      }
    end
  
    def show
      @user = User.find(params[:id])
      render json: {
        user: @user
      }
    end

  end