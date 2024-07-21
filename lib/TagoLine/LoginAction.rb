require 'rails/all'
require 'net/http'
require 'json'

module TagoLine
  class LoginAction

    def self.logoutProcess(controller,user_class=nil)
        controller.session.delete(:line_sub)
        controller.session.delete(:line_name)
        controller.session.delete(:line_picture)
        controller.session.delete(:line_state)
        if(user_class != nil)
            controller.session.delete(:user_id)
        end
    end

    def self.loginProcess(controller,user_class=nil)
        if controller.session[:line_sub] && controller.session[:line_sub].length > 0
            return true
        end

        if stateIsRight(controller)
            res = getAccessToken(controller)
            getUserInfo(controller, res["id_token"], user_class)
            return true
        else
            return false
        end
    end

    def self.stateIsRight(controller)
        controller.session[:line_state] == controller.params[:state]
    end


    def self.getUserInfo(controller, id_token, user_class=nil)
        uri = URI('https://api.line.me/oauth2/v2.1/verify')
        res = Net::HTTP.post_form(uri,'id_token' => id_token , 'client_id' => ENV['LINE_CHANNEL_ID'])
        controller.session[:line_sub] = JSON.parse(res.body)["sub"]
        controller.session[:line_name]= JSON.parse(res.body)["name"]
        controller.session[:line_picture]= JSON.parse(res.body)["picture"]

        if user_class != nil
            user = user_class.find_or_initialize_by(line_sub: JSON.parse(res.body)["sub"])
            user.line_name = JSON.parse(res.body)["name"]
            user.line_picture = JSON.parse(res.body)["picture"]
            logger.debug('heeeeeeeeeeeeeeeeeeeeee')
            user.save!

            controller.session[:user_id] = user.id
        end

        JSON.parse(res.body)
    end

    def self.getAccessToken(controller)
        uri = URI('https://api.line.me/oauth2/v2.1/token')
        res = Net::HTTP.post_form(uri, 'grant_type' => 'authorization_code', 'redirect_uri' => ENV['LINE_CALLBACK_URL'], 'client_id' => ENV['LINE_CHANNEL_ID'], 'client_secret' => ENV['LINE_CHANNEL_SECRET'], 'code' => controller.params[:code])
        # ##セッションにアクセストークンを保存
        # controller.session[:line_access_token] = JSON.parse(res.body)["access_token"]
        # ##セッションにexpires_inを保存
        # controller.session[:line_expires_in] = JSON.parse(res.body)["expires_in"]
        # ##セッションにid_tokenを保存
        # controller.session[:line_id_token] = JSON.parse(res.body)["id_token"]
        # ##セッションにrefresh_tokenを保存
        # controller.session[:line_refresh_token] = JSON.parse(res.body)["refresh_token"]
        JSON.parse(res.body)
    end

  end
end