FROM alpine:latest

ADD bin/example /usr/bin/

ENTRYPOINT /usr/bin/example

EXPOSE 70
