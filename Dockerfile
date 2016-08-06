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

# Remove dummy user/group accounts
ENV USER_KEEP='root\|mail' GROUP_KEEP='adm\|tty\|mail\|shadow\|utmp\|staff\|root'
RUN set -x \
    && cat /etc/passwd | cut -d':' -f1 | sed "/^${USER_KEEP}$/d"  | xargs -n 1 userdel \
    && cat /etc/group  | cut -d':' -f1 | sed "/^${GROUP_KEEP}$/d" | xargs -n 1 groupdel

ENV MONGO_VERSION=3.2
RUN set -x \
    && groupadd -g 999 mongodb \
    && useradd -u 999 -g 999 mongodb \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
    # Debian stretch for security updates
    && echo "deb http://http.debian.net/debian stretch main" >> /etc/apt/sources.list.d/mongodb.list \
    && echo 'Package: libc-bin libc6\nPin: release n=stretch\nPin-priority: 900\n\nPackage: *\nPin: release n=stretch\nPin-priority: -10' >> /etc/apt/preferences.d/stretch \
    # Upstream MongoDB repo
    && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/$MONGO_VERSION main" >> /etc/apt/sources.list.d/mongodb.list \
    && echo 'Package: mongodb-org*\nPin: release o=mongodb\nPin-priority: 995\n\nPackage: *\nPin: release o=mongodb\nPin-priority: -10' >> /etc/apt/preferences.d/mongodb \
    && apt-get update \
    && apt-get -y install libc-bin libc6 \
    && apt-get -y install mongodb-org \
    && apt-clean --aggressive

RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db

USER mongodb
VOLUME /data/db

COPY entrypoint /entrypoint
ENTRYPOINT ["/tini", "--", "/entrypoint"]
EXPOSE 27017
CMD ["mongod"]

