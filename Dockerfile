FROM crystallang/crystal:0.35.1-alpine-build as build-env
ENV BUILD_PACKAGES npm git upx nginx python xvfb sqlite-static
ENV AMBER_ENV production
WORKDIR /app

RUN apk --update --no-cache add $BUILD_PACKAGES

COPY shard.yml shard.lock ./
RUN set -ex && \
    shards install && \
    :

COPY package.json package-lock.json ./
RUN set -ex && \
    npm install && \
    :

COPY . /app

RUN set -ex && \
    nginx -t -c /app/config/nginx.conf && \
    crystal bin/ameba.cr && \
    npm run release && \
    shards build --static && \
    rm -f bin/xpaste && \
    shards build --release --static && \
    strip bin/xpaste && \
    upx -9 bin/xpaste && \
    rm -f bin/xpaste.dwarf && \
    :

FROM alpine:latest
ENV UPDATE_PACKAGES dcron nginx enca

WORKDIR /app

ENV AMBER_ENV production
ENV CRYSTAL_ENV production
# Fix for errbit
ENV RAILS_ENV production
ENV WEB_PORT 80

COPY --from=build-env /app/bin /app/bin
COPY --from=build-env /app/public /app/public
COPY --from=build-env /app/db /app/db
COPY --from=build-env /app/src/locales /app/src/locales
COPY --from=build-env /app/config/crontab /app/config/crontab
COPY --from=build-env /app/config/environments /app/config/environments
COPY --from=build-env /app/config/nginx.conf /etc/nginx/nginx.conf

RUN set -ex && \
    apk --update --no-cache -u add $UPDATE_PACKAGES && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /var/cache/apk/* && \
    :

RUN set -ex && \
    chown -R nginx:nginx /app/public && \
    nginx -t && \
    :

EXPOSE $WEB_PORT

CMD ["./bin/docker-entrypoint.sh"]
