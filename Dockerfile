FROM --platform=${TARGETPLATFORM} alpine:3.14.0 as builder

WORKDIR /root

RUN set -ex && \
    apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git && \
    cd vlmcsd/ && \
    make

FROM --platform=${TARGETPLATFORM} alpine:3.14.0
COPY --from=builder /root/vlmcsd/bin/vlmcsd /bin/vlmcsd

EXPOSE 1688/tcp

CMD [ "/bin/vlmcsd", "-D", "-d" ]