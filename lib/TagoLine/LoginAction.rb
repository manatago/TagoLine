require 'rails/all'
require 'net/http'
require 'json'

module TagoLine
  class LoginAction
    def self.stateIsRight(controller)
        controller.session[:line_state] == controller.params[:state]
    end

    def self.getAccessToken(controller)
        uri = URI('https://api.line.me/oauth2/v2.1/token')
        res = Net::HTTP.post_form(uri, 'grant_type' => 'authorization_code', 'redirect_uri' => ENV['LINE_CALLBACK_URL'], 'client_id' => ENV['LINE_CHANNEL_ID'], 'client_secret' => ENV['LINE_CHANNEL_SECRET'], 'code' => controller.params[:code])
        JSON.parse(res.body)
    end

  end
end