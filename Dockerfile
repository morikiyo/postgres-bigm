FROM postgres:14

RUN apt update \
 && apt install -y make gcc postgresql-server-dev-14 libicu-dev \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# NOTE: 証明書の有効期限がきれているためダウンロードできない
# https://ja.osdn.net/dl/pgbigm/pg_bigm-1.2-20200228.tar.gz
#
# ファイルをダウンロードしてチェックサムの一致を確認しておく
# https://pgbigm.osdn.jp/
# https://github.com/pgbigm/pg_bigm

WORKDIR /tmp
COPY ./pg_bigm-1.2-20200228.tar.gz .
RUN tar zxf pg_bigm-1.2-20200228.tar.gz
RUN cd pg_bigm-1.2-20200228 && make USE_PGXS=1 && make USE_PGXS=1 install

WORKDIR /
RUN rm -rf /tmp/pg_bigm-1.2-20200228

ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGINT

EXPOSE 5432
CMD ["postgres"]
