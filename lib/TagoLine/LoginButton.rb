require 'action_view'
module TagoLine
  class LoginButton
    def self.show()
      "<a href='https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1653867531&redirect_uri=https%3A%2F%2Ftago-line.herokuapp.com%2Fcallback&state=12345abcde&scope=profile%20openid%20email&nonce=09876xyz'>ログイン</a>".html_safe
    end
  end
end