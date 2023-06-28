FROM ruby:3.1.2-alpine

ENV LANG C.UTF-8

ARG APP_ROOT=/workspace
ARG BUILD_PACKAGES="build-base curl-dev ruby-dev"
ARG DEV_PACKAGES="yaml-dev zlib-dev mysql-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata ruby-json yaml"

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

ARG DATABASE_USER
ENV DATABASE_USER=${DATABASE_USER}

ARG DATABASE_PASSWORD
ENV DATABASE_PASSWORD=${DATABASE_PASSWORD}

ARG DATABASE_NAME
ENV DATABASE_NAME=${DATABASE_NAME}

RUN apk add --update \
  $BUILD_PACKAGES \
  $DEV_PACKAGES \
  $RUBY_PACKAGES

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

ENV GEM_HOME /$APP_ROOT/vendor/bundle
ENV BUNDLE_PATH /$APP_ROOT/vendor/bundle
ENV BUNDLE_BIN /$APP_ROOT/vendor/bundle/bin
ENV PATH $BUNDLE_BIN:$BUNDLE_PATH/gems/bin:$PATH

COPY ./docker/web/docker-entrypoint.sh /
COPY ./docker/web/wait-for-it.sh /
RUN chmod +x /docker-entrypoint.sh /wait-for-it.sh
