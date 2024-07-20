# frozen_string_literal: true

RSpec.describe TagoLine do
  it "has a version number" do
    expect(TagoLine::VERSION).not_to be nil
  end

  it "has a LoginButton" do
    expect(TagoLine::LoginButton.show).to eq("<a href='https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1653867531&redirect_uri=https%3A%2F%2Ftago-line.herokuapp.com%2Fcallback&state=12345abcde&scope=profile%20openid%20email&nonce=09876xyz'>ログイン</a>")
  end

end
