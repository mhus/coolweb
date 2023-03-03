FROM alpine

RUN apk add git gettext mysql-client
COPY data /data
CMD './data/checkout.sh'
