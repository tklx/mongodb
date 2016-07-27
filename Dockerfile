FROM tklx/base:0.1.0

ENV TINI_VERSION=v0.9.0
RUN set -x \
    && TINI_URL=https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && TINI_GPGKEY=0527A9B7 \
    && export GNUPGHOME="$(mktemp -d)" \
    && apt-get update && apt-get -y install wget ca-certificates \
    && wget -O /tini ${TINI_URL} \
    && wget -O /tini.asc ${TINI_URL}.asc \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${TINI_GPGKEY} \
    && gpg --verify /tini.asc \
    && chmod +x /tini \
    && rm -r ${GNUPGHOME} /tini.asc \
    && apt-get purge -y --auto-remove wget ca-certificates \
    && apt-clean --aggressive

RUN set -x \
    && apt-get update \
    && apt-get -y install mongodb-server \
    && apt-clean --aggressive

RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db

USER mongodb
VOLUME /data/db

COPY entrypoint /entrypoint
ENTRYPOINT ["/tini", "--", "/entrypoint"]
EXPOSE 27017
CMD ["mongod"]

