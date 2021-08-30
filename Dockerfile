FROM --platform=${TARGETPLATFORM} alpine:latest as builder

WORKDIR /root

RUN set -ex && \
    apk add --no-cache git build-base && \
    git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git && \
    cd vlmcsd/ && \
    make

FROM --platform=${TARGETPLATFORM} alpine:latest
COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd

RUN apk add --no-cache ca-certificates tzdata

ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
	echo "${TZ}" > /etc/timezone

EXPOSE 1688/tcp

CMD [ "/usr/bin/vlmcsd", "-D", "-d" ]