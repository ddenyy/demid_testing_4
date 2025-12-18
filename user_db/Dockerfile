FROM postgres:14.0
ENV POSTGRES_PASSWORD=secret
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=portal
COPY user_db.sql /docker-entrypoint-initdb.d/user_db.sql