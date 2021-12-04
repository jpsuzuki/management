# [Docker Rails6](https://qiita.com/me-654393/items/ac6f61f3eee66380ecd7)
- macのバージョンが変わって、シェルが変わった     
もしかしたらコマンドでエラーが出るかも。bash,zshの違いを確認すること

## 初期設定
### dockerfile
基本的に、コンテナ内で実行するコマンドが記述されてる    
`COPY　ローカルディレクトリ　コンテナ内`の読み方

### entrypoint
setでシェルの設定を確認。オプションでエラーが起こったときにシェルが終了するようにする   
プロセスIDをキル。dockerfileに記述されているCMDを一つづつ実行

### docker-compose
- DB    
    イメージをポスグレに指定。volumes: -ローカルのデータ：コンテナ内のデータ　でローカルのデータと同期させる
- web   
    volumesで、ローカル内とコンテナ内を同期させる   
    ポートを指定したり、DBを指定したり。    
    シェルでbash使ってるから注意が必要かも      


## コマンドの実行
### `docker-compose run web rails new . --force --no-deps --database=postgresql`    
webpackerについて色々警告が出た。
```
[1/4] Resolving packages...
warning @rails/webpacker > node-sass > request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
warning @rails/webpacker > node-sass > node-gyp > request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
warning @rails/webpacker > node-sass > node-gyp > tar@2.2.2: This version of tar is no longer supported, and will not receive security updates. Please upgrade asap.
warning @rails/webpacker > node-sass > request > har-validator@5.1.5: this library is no longer supported
warning @rails/webpacker > node-sass > request > uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
warning @rails/webpacker > webpack > watchpack > watchpack-chokidar2 > chokidar@2.1.8: Chokidar 2 will break on node v14+. Upgrade to chokidar 3 with 15x less dependencies.
warning @rails/webpacker > postcss-preset-env > postcss-color-mod-function > postcss-values-parser > flatten@1.0.3: flatten is deprecated in favor of utility frameworks such as lodash.
warning @rails/webpacker > webpack > node-libs-browser > url > querystring@0.2.0: The querystring API is considered Legacy. new code should use the URLSearchParams API instead.
warning @rails/webpacker > webpack > watchpack > watchpack-chokidar2 > chokidar > fsevents@1.2.13: fsevents 1 will break on node v14+ and could be using insecure binaries. Upgrade to fsevents 2.
warning @rails/webpacker > optimize-css-assets-webpack-plugin > cssnano > cssnano-preset-default > postcss-svgo > svgo@1.3.2: This SVGO version is no longer supported. Upgrade to v2.x.x.
warning @rails/webpacker > webpack > micromatch > snapdragon > source-map-resolve > resolve-url@0.2.1: https://github.com/lydell/resolve-url#deprecated
warning @rails/webpacker > webpack > micromatch > snapdragon > source-map-resolve > urix@0.1.0: Please see https://github.com/lydell/urix#deprecated
```

最後にWebpackerのインストール成功メッセージが表示される     
Webpacker successfully installed 🎉 🍰      
これが表示されたから一先ずはよし
- オプションについて
    - `--no-deps`   
        runコマンドのオプションリンクしたサービスを起動しない

    - `--force`
        rails newのオプション
        ファイルが存在する場合に上書き

    - `--database==postgresql`
        rails newのオプション
        データベースの指定

### docker-compose build
最後に下記のようなSuccess情報が表示される      
Successfully built aa99bbad99f9     
Successfully tagged myapp_web:latest    

はずなのだが、実際は`Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them`      
```
 => [11/11] RUN chmod +x /usr/bin/entrypoint.sh                       0.2s
 => exporting to image                                     2.9s
 => => exporting layers                2.8s
 => => writing image sha256:65b925f46ff10832c5758eac80a2db04d74d9d706a959ac8b3f2c59e3de25b1b   0.0s
 => => naming to docker.io/library/test_app_web
 ```

その後`docker-compose images`で確認するも、dbしかできてない

### docker-compose run web rake db:create
config/database.ymlを編集し、上記コマンドを実行     
これは資料通りの実行完了メッセージが出た

### docker-compose up
このコマンドでdockerを立ち上げ。localhost:3000で無事初期画面が表示された

## 開発中に使うコマンド
### docker-compose down
このコマンドでdockerの終了
### docker-compose up -d
コンテナの起動。バックグラウンドでやるのでターミナルを占領しない

### docker-compose ps 
起動中のコンテナの確認

### docker-compose logs 
サーバーログの確認
### docker-compose run web bundle exec rails コマンド
rails g controller などのrailsコマンドは上記のものを使う
`$ docker-compose run web bundle exec `でwebコンテナ内でのコマンドを実行出来る
gitへのプッシュなどはローカルのファイルを送ればいいから上記コマンド使う必要はないかも

### docker-compose exec web /bin/bash
コンテナのシェルを起動。`docker-compose exec web ~~~`と入力しなくてもコマンドが実行できる
exit で退出

### `docker-compose build` , `docker-compose up -d`
Dockerfile Gemfileの変更を反映させたい場合に使う
downさせてからのが良さげ？


## 開発メモ(実行)
### github登録
[ssh鍵を生成](https://git-scm.com/book/ja/v2/Git%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC-SSH-%E5%85%AC%E9%96%8B%E9%8D%B5%E3%81%AE%E4%BD%9C%E6%88%90)し、githubに登録。プッシュできるようになる

### [Bootstrapのインストール](https://qiita.com/oak1331/items/3b4ebf9b076246c103f4)
- パッケージインストール
```
$ yarn add bootstrap@next
$ yarn add @popperjs/core
```
- 各ファイルでの設定
application  .js  .scss  .html.erb  の３つ

- 詳細はリンクから

### rails generate controller StaticPages home
とりあえずビューが欲しいのでhomeアクションを追加
routes.rbに`root 'static_pages#home'`と記述。

## 開発メモ(構想)
- ユーザ機能作成
- 管理者など限られたユーザ、もしくは既存のユーザしか新しいユーザを追加できないようにする
- ユーザに時給(wage)カラム。管理者のみ変更権限
- 勤怠時間テーブル  
外部キーにユーザ、日付、出勤時刻、退勤時刻  
出勤ボタンでデータを作成、退勤ボタンで同じオブジェクトに退勤時刻を追加
- 20日にメールを送信、データのリセットをする

## 開発日記
### 11/16     
環境構築をした。これでローカルでの開発ができる      
加えてビューを一つ作ってルートに置いた。また、タイトルも変えれるようにした  
ひとまずはapp/views/layouts/application.html.erbの編集。bootstrapは使えるようになってるはずなので、ヘッダーを作成する   
その後、user機能を追加。トップをログイン画面にする。まずはマスターを一人作成。  
あとは何を作るかによって変わる。勤怠管理かメニューか予約システムか  
今のところは勤怠管理を考えてる

### 11/17     
レイアウトの作成、usersコントローラを作成。     
モデルを作成しようと思うが、データ属性を考えないといけない      
カラオケ屋のを参考にすれば、従業員番号とパスワードと名前をユーザテーブルに作って、それを外部キーとして勤怠情報などのデータを紐付けるか
管理者権限も必要となるとadminも？   
ひとまずはnumber,nameで作り、passwordをつけ、ビューを整えたらadminも考えるか
`rails g model User name:string number:integer`     
上記を実行する。バリデーションを記述し、パスワードを追加。その後indexアクションで一覧表示できるようにし、フォームを作成して作ってみて確認したり。

### 11/18     
上記コマンドを実行した時、エラー発生。ルーティングに構文エラー      
結果、シングルクォーテーションのところにバッククォーテーションを使ってた。  
modelを作成しようとしたが、numはstringにして正規表現で数字にすべき？フォームさえ気を付ければintegerのが良いか？     
何にせよ次こそモデルを作る。    
↑めんどそうだから整数型で良い

### 11/19     
integerだと 0001 = 1 と認識されるっぽい？   
stringにしてフォーマットを限定させる形で実装しなおす    
正規表現だと`ˆ[0-9][0-9][0-9][0-9]$`で４桁の数字になる
`ˆ[]$`と`\A[]\z`は大体同じ意味。文字列の頭からか行の頭からかの違いがあるっぽいけど      
testを行ったらエラー。削除したテストになぜか引っかかってる      
↑each文のendを書き忘れてた。テストはグリーン    
モデルではメモリ内のデータの検証はできるが、データベースでも一意性を保つためにはインデックスを作らないといけない    
`rails generate migration add_index_to_users_number`    
    ```
        def change
            add_index :users, :number, unique: true
        end
    ```
`rails db:migrate`
userモデルの基礎はできた。次はパスワードの追加


### 11/23
- パスワードの追加
    - モデルに`has_secure_password`と記述     
        ハッシュ化したパスワードを、データベース内のpassword_digestという属性に保存     
        2つのペアの仮想的な属性（passwordとpassword_confirmation）が使える      
        authenticateメソッドが使えるようになる（引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返す
    - userにpassword_digestを追加
    `$ rails generate migration add_password_digest_to_users password_digest:string`
    `rails db:migrate`
    - gem bcrypt を追加
- first user(鈴木健太郎,0000,"foobarbaz")
- routes.rb usersリソース
- Digestライブラリのhexdigestメソッドを使うと、MD5のハッシュ化できる(やってはいない)
```
>> email = "MHARTL@example.COM"
>> Digest::MD5::hexdigest(email.downcase)
=> "1fda4469bcbec3badf5418269ffc5968"
```

### 11/24
- show,index,editページを追加
- 登録、編集フォーム作成
- bcrypt が反映されてないらしく、ユーザオブジェクトが機能しない     
→ビルドし直す
- cssでエラー。見直し
- editのテスト失敗。見直し
- users リソース
    HTTPリクエスト	|URL	|アクション	|名前付きルート	|用途
    -|-|-|-|-
    GET	|/users	|index	|users_path	|すべてのユーザーを一覧するページ
    GET	|/users/1	|show	|user_path(user)	|特定のユーザーを表示するページ
    GET	|/users/new	|new	|new_user_path	|ユーザーを新規作成するページ（ユーザー登録）
    POST|/users	|create	|users_path	|ユーザーを作成するアクション
    GET	|/users/1/edit	|edit	|edit_user_path(user)	|id=1のユーザーを編集するページ
    PATCH	|/users/1	|update	|user_path(user)	|ユーザーを更新するアクション
    DELETE	|/users/1	|destroy	|user_path(user)	|ユーザーを削除するアクション
- userモデルにdigestメソッドを定義  
secure_passwordのソースコードから
- cssをwebpackのファイルに移動
- リビルド
- /signupで無効の送信からのリダイレクトが/usersになる。確認
- フォームを使って登録、その他アクションを実装
- ログイン機能追加

### 11/25 
- 登録フォームで実際に登録を試みる  
→numberがエラー。おそらくbootstrapがemailと誤認している     
→フォームをemail_fieldにしているのが原因だった
- rails g controller アクション名　で、アクションを指定すると、それに対応したビューも作成される
- form_withではモデルを指定すれば「フォームのactionは/usersというURLへのPOSTである」と自動的に判定      
セッションはモデルが無いし、urlも/session/newじゃないから、urlを指定してあげる      
```
form_with(url: login_path, scope: :session, local: true)
```
- sessionコントローラとフォームを作成。機能はまだ

### 11/26
- application_controller.rbにヘルパーモジュールを読み込ませた   
`include SessionsHelper`[メソッドをパッケージ化](https://railstutorial.jp/chapters/rails_flavored_ruby?version=6.0#sec-back_to_the_title_helper)
- log_inメソッドの定義
- current_userメソッドの定義
- sessionのcreateアクション
- log_in?メソッドの定義

- 次やること
    - ログインのテスト
    - ログアウト

### 11/27
#### 実行
- flashメッセージが表示されるようにレイアウトに記述
- flash.nowとすることで、その後にリクエストが発生したらflashが消えるように
- testヘルパーメソッド`is_login?`を定義
- ログアウト機能(session deleteアクション)を実装
#### メモ
- チュートリアルでは登録後に自動でログインされるようにしてあるけど、これは実装しないでおく
- 
#### 次
- 認可機能
- レイアウト


### 11/28
#### 実行
- user edit パスワードなしでも変更できるように、モデルにallow nilと記述
- before_action追加
- log_in_asテストヘルパーメソッドを定義
- インテグレーションテストのヘルパーは、同じファイルでも`ActionDispatch::IntegrationTest`クラスに記述
#### メモ
- integration/users_edit_testがエラー。log_in_asテストヘルパーメソッドをインテグレーションテストでも定義        
クリア
- sessions_controller_testもエラー。別件っぽい      
↑sessipn_new_urlにアクセスする記述をlogin_pathに直したらクリア
#### 次
- 認可機能
- adminユーザ

### 12/1
#### 実行
- before_action current_user
- user_controller_test
- admin属性追加
####　メモ
- rails t　失敗     
log_in_asメソッドのuser.numberが効かない
⇨setupで@other_userを定義していなかった
- フレンドリーフォワーディングは実装せずスキップ    
新規ユーザフォーム⇨管理者ログイン⇨ユーザフォームなると便利？
- ページネーション機能。勤怠情報は23日分ほどあるので使うか？       
ユーザ一覧では使わないからスキップ
- before_action admin_userでフラッシュを追加する
- 認可機能は複雑になりそうなので、とりあえず使うべきデータを用意する？何にせよ設計を考えないといけない
- ログイン時にリダイレクト先を分岐。adminでif分岐
#### 次
- 10.4.1の演習にあるテスト  
web経由でのadmin属性変更禁止のテスト
- ユーザ削除のテスト
- before_action admin_userでフラッシュを追加する
- ページ設計、認可設計

### 12/2
#### 実行
- user_controller_test
    - admin権限をwebで与えない
    - before action admin user
- before action admin user にindex アクションも追加
- login時にadminは別ページにする様分岐
    - login test のuser をarcherに

####　メモ
- timeモデル作成のため、現在時刻を取得する方法を調べる
    - Time.nowで現在時刻、メソッドチェーンで時間のみとかできるっぽい
    - rubyでのメソッドらしい。railsは別の方法をした方が良い？

#### 次
- 現在時刻の取得方法調べる。
- 日本時間に設定
- 時間計算

### 12/4
#### 実行
- docker-composeファイルの環境変数を設定    
環境変数は設定できたが、Time.nowは変わらなかった。調べる    
環境変数設定時、`TZ='Asia/Tokyo'`だと失敗。`TZ=Asia/Tokyo`で動く
- application.rbにタイムゾーンを設定    
    - rails c `Time.current`は日本時間になった
    - `Time.now`はこれでは変わらない
    - config.active_record.default_timezoneはDBに読み書きする時刻に影響する
    - [参考](https://qiita.com/aosho235/items/a31b895ce46ee5d3b444)
- workモデルを作成。    
    `rails g model Work start:time end:time day:date user:references`
####　メモ
- Timeメソッドで現在時刻の取得に成功。
- 次はどうやってデータベースに保存するか、またどうやって計算するか
```
# 年
Time.current.year
=> 2020

# 月
Time.current.month
=> 6

# 日付
Time.current.day
=> 7
```
- 日付は出勤時の時間    
退勤時間ー出勤時間＝労働時間    
退勤時間＜出勤時間（24時を越した場合の計算）    
#### 次
- コンソールでデータ作成。  
    - Time.currentがそのまま送れるか
    - 計算
- コントローラも作ってアクションも整えてからテストを書いた方が良い？
- その際はルーティングも設定する



