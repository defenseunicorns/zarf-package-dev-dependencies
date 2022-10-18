#!/bin/bash

# Update CA Certs that were potentially volumed into the pod
update-ca-certificates

export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export TWINE_CERT=/etc/ssl/certs/ca-certificates.crt

# Set the npm credentials
npm config set cafile /etc/ssl/certs/ca-certificates.crt
npm config set registry https://github.com/uploading/a/npm/
NPM_TOKEN="62db174df522aab21078c1f67c228f52e9ce24f7"
npm config set -- "//github.com/uploading/a/npm/:_authToken" "$NPM_TOKEN"

tail -f /dev/null
