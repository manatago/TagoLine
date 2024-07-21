require 'action_view'
module TagoLine
  class LoginButton
    def self.show()
      text = this.buttonStyle()
      text+="<a class='line_login_button' href='https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1653867531&redirect_uri=https%3A%2F%2Ftago-line.herokuapp.com%2Fcallback&state=12345abcde&scope=profile%20openid%20email&nonce=09876xyz'>ログイン</a>".html_safe
      text
    end

    def self.buttonStyle()
      "<style>
        .line_login_button {
          width: 142px;
          height: 40px;
          background-repeat: no-repeat;
          background-size: cover;
          background-image:url('data:image/png;base64,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')
        }
      </style>".html_safe
    end
  end
end