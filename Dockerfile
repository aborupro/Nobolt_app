FROM ruby:2.4.9

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs \
                       vim

# ルート直下にNobolt_appという名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /Nobolt_app
Env APP_ROOT /Nobolt_app
WORKDIR $APP_ROOT

# ホストのGemfileとGemfile.lockをコンテナにコピー
ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
ADD . $APP_ROOT

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
