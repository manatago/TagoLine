require 'action_view'

module TagoLine
  class LogoutButton

    def self.show(logout_path)
      text = buttonStyle()
      text+="<a class='line_logout_button' href='"+logout_path+"'>Log out</a>"
      text.html_safe
    end

    def self.buttonStyle()
      "<style>
        .line_logout_button {
            width: 142px;
            height: 40px;
            display: block;
            background-color: #06C755;
            color:white;
            text-decoration: none;
            text-align: center;
            line-height: 40px;
            vertical-align: middle;
            font-weight: bold;
            font-size: 20px;
            border-radius: 5px;
            opacity: 0.8;
        }
        .line_login_button:hover{
            opacity: 0.9;
        }
        .line_login_button:active{
            opacity: 1;
        }
        </style>"
    end
  end
end