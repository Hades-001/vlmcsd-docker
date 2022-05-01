FROM --platform=${TARGETPLATFORM} debian:11 as builder

ARG TAG
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root

RUN set -ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates git gcc make libc-dev && \
    git clone https://github.com/Wind4/vlmcsd.git vlmcsd && \
    cd ./vlmcsd && \
    git fetch --all --tags && \
    git checkout tags/${TAG} && \
    make

FROM --platform=${TARGETPLATFORM} gcr.io/distroless/base-debian11
COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd

ENV TZ=Asia/Shanghai

EXPOSE 1688/tcp

CMD [ "/usr/bin/vlmcsd", "-D", "-d" ]