ARG version=0.40.1
ARG base_image=ghcr.io/h0tw1r3/alpine-fips:3.20.3

FROM docker.io/timberio/vector:${version}-alpine AS vector

FROM ${base_image}

RUN apk --no-cache add ca-certificates tzdata openssl

COPY --from=vector /usr/local/bin/* /usr/local/bin/
COPY --from=vector /etc/vector /etc/
COPY --from=vector /var/lib/vector /var/lib/

RUN vector --version

ENTRYPOINT ["/usr/local/bin/vector"]
