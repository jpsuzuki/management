# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "test_app"
set :repo_url, "git@github.com:jpsuzuki/management"
set :branch, "main"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ec2-user/test_app/"

set :keep_releases, 2
# ssh接続をする際に必要な設定を書きます。
set :ssh_options, {
  # capistranoコマンド実行者の秘密鍵
  port: 22,
  keys: %w(~/.ssh/test_app_key.pem),
  forward_agent: true,
  auth_methods: %w(publickey)
}

# Railsがproduction.keyを参照するためのシンボリックリンクを貼る記述をします。production.keyについては後述
append :linked_files, 'config/credentials/production.key'
# 同じくシンボリックリンクを貼るフォルダを指定します。記載したフォルダがshared下に作られます。
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :rbenv_type, :user
set :rbenv_ruby, '2.6.6'
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.conf.rb" }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end