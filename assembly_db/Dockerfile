FROM postgres:14.0
ENV POSTGRES_PASSWORD=secret
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=builds
COPY assembly_db.sql /docker-entrypoint-initdb.d/assembly_db.sql