FROM ruby:2.6.6

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && apt-get install -y build-essential nodejs

# yarnパッケージ管理ツールインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# ルート直下にwebappという名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /webapp
WORKDIR /webapp

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /webapp/Gemfile
COPY Gemfile.lock /webapp/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . /webapp

# unicorn.pidを配置するディレクトリを作成
RUN mkdir -p tmp/pids
# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets