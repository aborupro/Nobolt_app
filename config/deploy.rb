# config valid for current version and patch releases of Capistrano

lock '~> 3.16.0'

# デプロイするアプリケーション名
set :application, 'Nobolt_app'

# cloneするgitリポジトリ名
set :repo_url, 'git@github.com:aborupro/Nobolt_app.git'

# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/Nobolt_app'

# # シンボリックリンクをはるファイル
# set :linked_files, fetch(:linked_files, []).push('config/settings.yml')
set :linked_files, fetch(:linked_files, []).push('config/master.key')

# シンボリックリンクをはるフォルダ
set :linked_dirs,
    fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system',
                                 'public/uploads', 'environments')

# 保持するバージョンの個数
set :keep_releases, 3

# rubyのバージョン
set :rbenv_ruby, '2.4.9'

set :bundle_jobs, 2

# #出力するログのレベル。
# set :log_level, :debug
