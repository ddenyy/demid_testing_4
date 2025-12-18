FROM alpine:latest

RUN apk add --no-cache ca-certificates unzip

ADD https://github.com/improbable-eng/grpc-web/releases/download/v0.15.0/grpcwebproxy-v0.15.0-linux-x86_64.zip /tmp/

RUN unzip /tmp/grpcwebproxy-v0.15.0-linux-x86_64.zip -d /tmp/ && \
    mv /tmp/dist/grpcwebproxy-v0.15.0-linux-x86_64 /usr/local/bin/grpcwebproxy && \
    chmod +x /usr/local/bin/grpcwebproxy && \
    rm -rf /tmp/dist /tmp/grpcwebproxy-v0.15.0-linux-x86_64.zip


EXPOSE 8080

CMD ["grpcwebproxy", "--backend_addr=app:50051", "--run_tls_server=false", "--allow_all_origins"]
