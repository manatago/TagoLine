require 'rails/all'
require 'net/http'
require 'json'

module TagoLine
  class LoginAction

    def self.logoutProcess(controller)
        controller.session.delete(:line_sub)
        controller.session.delete(:line_name)
        controller.session.delete(:line_picture)
        controller.session.delete(:line_state)
    end

    def self.loginProcess(controller)
        if controller.session[:line_sub] && controller.session[:line_sub].length > 10
            return true
        end

        if stateIsRight(controller)
            res = getAccessToken(controller)
            getUserInfo(controller, res["id_token"])
            return true
        else
            return false
        end
    end

    def self.stateIsRight(controller)
        controller.session[:line_state] == controller.params[:state]
    end


    def self.getUserInfo(controller, id_token)
        uri = URI('https://api.line.me/oauth2/v2.1/verify')
        res = Net::HTTP.post_form(uri,'id_token' => id_token , 'client_id' => ENV['LINE_CHANNEL_ID'])
        controller.session[:line_sub] = JSON.parse(res.body)["sub"]
        controller.session[:line_name]= JSON.parse(res.body)["name"]
        controller.session[:line_picture]= JSON.parse(res.body)["picture"]
        JSON.parse(res.body)
    end

    def self.getAccessToken(controller)
        uri = URI('https://api.line.me/oauth2/v2.1/token')
        res = Net::HTTP.post_form(uri, 'grant_type' => 'authorization_code', 'redirect_uri' => ENV['LINE_CALLBACK_URL'], 'client_id' => ENV['LINE_CHANNEL_ID'], 'client_secret' => ENV['LINE_CHANNEL_SECRET'], 'code' => controller.params[:code])
        JSON.parse(res.body)
    end

  end
end