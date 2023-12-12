# syntax=docker/dockerfile:1

FROM jyx5678/php_env:1.0

# set version label
#LABEL build_version="1.0.0"
#LABEL maintainer="jyxgood"

#ENV S6_STAGE2_HOOK="/init-hook"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    fontconfig \
    mariadb-client \
    memcached \
    php82-dom \
    php82-gd \
    php82-ldap \
    php82-mysqlnd \
    php82-pdo_mysql \
    php82-pecl-memcached \
    php82-tokenizer \
    qt5-qtbase \
    ttf-freefont && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php82/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php82/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php82/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php82/php-fpm.conf && \
  echo "**** fetch bookstack ****" && \
  mkdir -p\
    /app/www && \
  curl -o \
    /tmp/bookstack.tar.gz -L \
    "https://codeload.github.com/BookStackApp/BookStack/tar.gz/refs/tags/v23.10.4" && \
  tar xf \
    /tmp/bookstack.tar.gz -C \
    /app/www/ --strip-components=1 && \
  echo "**** install composer dependencies ****" && \
  composer install -d /app/www/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    $HOME/.cache \
    $HOME/.composer

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
