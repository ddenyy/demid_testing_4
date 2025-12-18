FROM postgres:14.0
ENV POSTGRES_PASSWORD=secret
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=components
COPY components_db.sql /docker-entrypoint-initdb.d/components_db.sql