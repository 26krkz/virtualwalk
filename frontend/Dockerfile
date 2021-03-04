#nodeイメージをpullする
FROM node:14.16.0-alpine

#working directory
WORKDIR /webapp

RUN apk update && \
    npm install -g npm && \
    npm install -g @vue/cli

# COPY package*.json ./
# RUN npm install

CMD ["/bin/sh"]