# TagoLine使い方
## 前提条件
下記の環境変数が設定されていることが前提となります。
```
LINE_CALLBACK_URL
LINE_CHANNEL_ID
LINE_CHANNEL_SECRET
```

## このGemの基本理念
Line等のプラットフォームを使ってログインする場合は、できることは多い。
Lineでも普通は
- ログインする
- リダイレクトのURLパラメーターでcodeを受け取る
- codeをLineに送ってアクセストークン、リフレッシュトークン、idトークンなど色々受け取る。
- アクセストークンをすでに持っている時は、その有効性を確認する。
  有効である場合は上のプロセスは実行しなくて良い
- idトークンも持っていれば上のプロセスは不要
- idトークンを送って個人情報を取得する
- アクセストークンを持っている場合はリフレッシュトークンを利用してアクセストークンを更新できる

とか、ものすごく複雑になる。

このGemではそんな面倒なことをせず

- ログインページからリダイレクト
- codeを受け取る
- idトークンを受け取り、それをLineに送る
- アカウントの情報を受け取る
だけをやることにした。

CSRF対策になるようにstateのチェックはしているがnoceなどは使っていない。


# 使い方

基本的な使い方は次の２つだけです

## ログインボタン
ビューの中でこう書きます。
```
<%= TagoLine::LoginButton.show(controller) %>
```
セッションを使うため、引数にcontrollerが必要です

## ログインのプロセス
```
TagoLine::LoginAction.loginProcess(self)
```
リダイレクト先のコントローラーのアクションでまずこのように書く。

こうすると
sessionの中にline_sub,line_name,line_pictureが入ります。
ログインできればtrue,できない場合はfalseが帰ります

また、これ以外にもlogoutProcessを用意しており、そこでセッションの中身をクリアします


## ログアウトボタン
ビューの中でこう書きます。
```
<%= TagoLine::LogoutButton.show("/logout") %>
```
ログアウト先のパスを引数にします。


使い方は以上です。
これ以上複雑にすると、わけわからんくなるので、これ以上は基本複雑にしないようにします。


# 実際の使用例
## ログインしてリダイレクトしてきたところ
```
  def top

    #セッションにユーザーIDがあればそのままトップページを表示して終わる
    if session[:user_id].present?
      render template: "home/top"
      return
    end

    #stateとcodeがない場合はトップページにリダイレクトする
    if params[:state].blank? || params[:code].blank?
      redirect_to "/"
      return
    end

    #セッションにユーザーIDがない場合はログイン処理を行う
    if !TagoLine::LoginAction.loginProcess(self)
      render plain: "login error"
      return
    end
    #ログイン処理が成功した場合はユーザー情報を取得してDBに保存する
    if session[:line_sub].present? && session[:line_name].present?
      user = User.find_or_initialize_by(line_sub: session[:line_sub])
      user.line_name = session[:line_name]
      user.line_picture = session[:line_picture]
      user.save
      session[:user_id] = user.id
    end
  
  end
```


## ログアウトの処理

```
  def logout
    session.delete(:user_id)
    TagoLine::LoginAction.logoutProcess(self)
    redirect_to "/"
  end
```




