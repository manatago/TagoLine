require 'action_view'
require 'rails/all'

module TagoLine
  class LoginButton

    def self.show(controller)
      line_state = ('a'..'z').to_a.shuffle[0..7].join
      controller.session[:line_state] = line_state
      text = buttonStyle()
      text+="<a class='line_login_button' href='https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id="+ENV["LINE_CHANNEL_ID"]+"&redirect_uri="+ENV["LINE_CALLBACK_URL"]+"&state="+line_state+"&scope=profile%20openid%20email&nonce=09876xyz'></a>"
      text.html_safe
    end

    def self.buttonStyle()
      "<style>
        .line_login_button {
          width: 142px;
          height: 40px;
          display: block;
          background-repeat: no-repeat;
          background-size: cover;
          background-image:url('data:image/png;base64,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')
        }
        .line_login_button:hover{
          background-image:url('data:image/png;base64,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')
        }
        .line_login_button:active{
          background-image:url('data:image/png;base64,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')
        }
      </style>"
    end
  end
end