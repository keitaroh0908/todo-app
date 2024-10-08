FROM --platform=linux/amd64 node:18-alpine as builder
ENV NODE_ENV production

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./
RUN yarn install

COPY ./ ./
RUN yarn build

FROM --platform=linux/amd64 nginx:stable-alpine as runner

COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
