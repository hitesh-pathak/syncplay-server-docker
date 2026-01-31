ARG IMG_TAG="3.13-alpine"

FROM python:${IMG_TAG} AS base

ARG SYNCPLAY_VER
ENV SYNCPLAY_PORT=8999

# Dependencies
RUN apk add --no-cache --update --progress \
  make \
  curl

RUN pip3 install --upgrade pip && \
  pip3 install \
  twisted \
  certifi \
  pyopenssl \
  service_identity \
  idna \
  pem

# Build
RUN mkdir -p /tmp/syncplay-build
WORKDIR /tmp/syncplay-build

RUN curl -L -o syncplay.tar.gz \
  https://github.com/Syncplay/syncplay/archive/refs/tags/v${SYNCPLAY_VER}.tar.gz \
  && tar -xzf syncplay.tar.gz

WORKDIR /tmp/syncplay-build/syncplay-${SYNCPLAY_VER}
RUN make install-server

# Clean
RUN rm -rf /tmp/syncplay-build
WORKDIR /

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE ${SYNCPLAY_PORT}

ENTRYPOINT ["/entrypoint.sh"]
