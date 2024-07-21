require 'rails/all'
require 'net/http'
require 'json'

module TagoLine
  class LoginAction
    def self.stateIsRight(controller)
        controller.session[:line_state] == controller.params[:state]
    end


    def self.getUserInfo(id_token)
        uri = URI('https://api.line.me/oauth2/v2.1/verify')
        res = Net::HTTP.post_form(uri,'id_token' => id_token , 'client_id' => ENV['LINE_CHANNEL_ID'])
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