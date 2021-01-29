ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8
ARG BUILD_ARCH
ARG BUILD_VERSION

COPY run.sh /

RUN set -x \
 && apk add --no-cache curl \
 && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
 && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
 && if [[ "${BUILD_ARCH}" = "armhf" ]]; then ARCH="arm"; fi \
 && if [[ "${BUILD_ARCH}" = "armv7" ]]; then ARCH="arm"; fi \
 && if [[ "${BUILD_ARCH}" = "i386" ]]; then ARCH="386"; fi \
 && curl -Lo /frp.tar.gz https://github.com/fatedier/frp/releases/download/v${BUILD_VERSION}/frp_${BUILD_VERSION}_linux_${ARCH}.tar.gz \
 && tar -xzf /frp.tar.gz \
 && rm -f /frp.tar.gz \
 && mv frp_${BUILD_VERSION}_linux_${ARCH}/ frp


CMD [ "/run.sh" ]