FROM postgres:latest as psql

WORKDIR /db
COPY 2018-07-18-15.sql /db
COPY init_db.sh /docker-entrypoint-initdb.d
COPY init_user.sh /docker-entrypoint-initdb.d

EXPOSE 5432
CMD ["postgres"]
