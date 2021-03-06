#!/bin/bash

set -e

S3_BUCKET_ACL=${S3_BUCKET_ACL:-public-read}
PACKAGE_ARGS=${PACKAGE_ARGS}
PUSH_ARGS=${PUSH_ARGS:---ignore-if-exists}

echo "==> Init"
[[ ! -z "${S3_BUCKET}" ]] || (echo "ERROR: S3_BUCKET variable is required" && exit 1)
helm repo add myrepo ${S3_BUCKET} > /dev/null 2>&1 \
    || (
        helm s3 init --acl=${S3_BUCKET_ACL} ${S3_BUCKET} \
        && helm repo add myrepo ${S3_BUCKET} > /dev/null 2>&1 \
    )

cp -r /charts/* /apps/

while IFS= read -r d; do 
    echo "==> Found ${d}"

    echo -n " - packaging: "
    helm package ${PACKAGE_ARGS} ${d}

    echo -n " - pushing:   "
    helm s3 push --acl=${S3_BUCKET_ACL} ${PUSH_ARGS} ${d}-*.tgz myrepo
    echo "Pushed to ${S3_BUCKET}"
done < <(find * -prune -type d)