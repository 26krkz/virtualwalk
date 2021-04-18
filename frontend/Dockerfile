#nodeイメージをpullする
FROM node:14.16.0-alpine

#working directory
WORKDIR /webapp

RUN apk update

COPY package*.json ./
RUN npm install

CMD ["/bin/sh"]