class Api::V1::UsersController < Api::V1::BaseController
    
    URL = "https://api.weixin.qq.com/sns/jscode2session".freeze 

    def wechat_params
        { appid: ENV['APPID'],
          secret: ENV['SECRET'],
          js_code: params[:code], grant_type: "authorization_code" }
    end

    def wechat_user
        @wechat_response ||= JSON.parse(RestClient.post( URL, wechat_params )) 
    end

    def login
        @user = User.find_or_create_by(open_id: wechat_user.fetch("openid"))
        render json: { userId: @user}
    end

    def update_user_info
        @user = User.find(params[:id])
        @user.name = params[:name]
        @user.nationality = params[:nationality]
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