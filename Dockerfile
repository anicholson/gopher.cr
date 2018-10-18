FROM durosoft/crystal-alpine:latest as builder

RUN mkdir -p /opt/gopher

ARG CRFLAGS
ARG PUBLIC_PORT

ADD . /opt/gopher

WORKDIR /opt/gopher

RUN shards build $CRFLAGS

FROM scratch

EXPOSE 70

VOLUME "/gopher"

COPY --from=builder /opt/gopher/bin/example /

ENTRYPOINT ["/example"]

