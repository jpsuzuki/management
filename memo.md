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

### `docker-compose build` , `docker-compose up -d`
Dockerfile Gemfileの変更を反映させたい場合に使う
downさせてからのが良さげ？


