FROM node:8.4.0

# yarn はデフォルトで入ってるっぽい。

WORKDIR /front

COPY package.json yarn.lock /front/

RUN yarn install
