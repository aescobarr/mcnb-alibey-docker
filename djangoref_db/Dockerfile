FROM mdillon/postgis:10
RUN mkdir -p /tmp/psql_data/
WORKDIR /tmp/psql_data/
COPY scripts/alibey_schema.sql /tmp/psql_data/
COPY scripts/alibey_init_data.sql /tmp/psql_data/
COPY scripts/init_database.sh /docker-entrypoint-initdb.d/