FROM --platform=linux/arm64 quay.io/coreos/coreos-installer:v0.14.0

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

VOLUME /data

WORKDIR /data