# syntax=docker/dockerfile:1

FROM jyx5678/php_env:1.0

# set version label
LABEL build_version="1.0.0"
LABEL maintainer="jyxgood"

ENV S6_STAGE2_HOOK="/init-hook"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    fontconfig 

# ports and volumes
EXPOSE 80 443
