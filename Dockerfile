FROM golang:1.20 as builder
WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 go build -o proxy .

FROM alpine:latest

COPY --from=builder /app/proxy /app/proxy

ENV BACKEND_PORT=3306
ENV BACKEND_HOST=localhost
ENV PROXY_PORT=3307
ENV SERVER_CERT=/etc/server-cert.pem
ENV SERVER_KEY=/etc/server-key.pem

CMD ["sh", "-c", "/app/proxy ${PROXY_PORT} ${BACKEND_HOST} ${BACKEND_PORT} ${SERVER_CERT} ${SERVER_KEY}"]
