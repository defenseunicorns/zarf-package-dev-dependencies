#!/bin/bash

# Update CA Certs that were potentially volumed into the pod
update-ca-certificates

export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export TWINE_CERT=/etc/ssl/certs/ca-certificates.crt

#####
# Upload all the PyPI packages
#####
python3 -m twine upload --repository-url=https://pypi.org/ \
                       -u=redirector -p=replaces \
                       --skip-existing \
                       --verbose \
                       /packages/pypi/*  

# Set the npm credentials
npm config set cafile /etc/ssl/certs/ca-certificates.crt
NPM_TOKEN="cabdeadbeefdeaffeeddabbadfaddadfedbedfeb"
npm config set -- "//registry.npmjs.org/:_authToken" "$NPM_TOKEN"

# Publish the npm package
for NPM_PACKAGE in /packages/npm/*; do
    npm publish $NPM_PACKAGE
done

#####
# Upload all the generic packages
#####
pushd /packages/generic
PACKAGES="$(cat manifest.json | jq -r 'keys[]')"
IFS='
'
set -f
for LINE in $PACKAGES; do
    URL="$(cat manifest.json | jq --arg package $LINE -r '.[$package]')"
    echo -e "Uploading ${URL}"
    curl -X PUT --upload-file "${LINE}" "${URL}"
done
set +f
unset IFS
popd
