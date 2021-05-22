# EC2サーバーのIP、EC2サーバーにログインするユーザー名、サーバーのロールを記述
server '18.178.60.111', user: 'nobolt-hara', roles: %w[app db web]

# デプロイするサーバーにsshログインする鍵の情報を記述
set :ssh_options, keys: '~/.ssh/Nobolt-key.pem'
