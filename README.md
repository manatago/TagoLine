# TagoLine使い方
## 前提条件
下記の環境変数が設定されていることが前提となります。
```
LINE_CALLBACK_URL
LINE_CHANNEL_ID
LINE_CHANNEL_SECRET
```

## ログインボタン
ビューの中でこう書きます。
```
<%= TagoLine::LoginButton.show(controller) %>
```
セッションを使うため、引数にcontrollerが必要です