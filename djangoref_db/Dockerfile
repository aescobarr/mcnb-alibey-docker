FROM mdillon/postgis:10
RUN mkdir -p /tmp/psql_data/
WORKDIR /tmp/psql_data/
COPY scripts/djangoref_now.sql /tmp/psql_data/
COPY scripts/init_database.sh /docker-entrypoint-initdb.d/