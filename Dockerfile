FROM alpine/helm:3.1.2

RUN apk add --no-cache \
    git \
    bash

RUN helm plugin install https://github.com/hypnoglow/helm-s3.git

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

ENTRYPOINT [ "/opt/docker-entrypoint.sh" ]
