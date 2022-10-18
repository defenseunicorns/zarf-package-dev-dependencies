#!/bin/bash

# Update CA Certs that were potentially volumed into the pod
update-ca-certificates

export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export TWINE_CERT=/etc/ssl/certs/ca-certificates.crt

ZARF_USER=$(cat /etc/zarf-state/state | jq -r '.gitServer.pushUsername')
ZARF_PASS=$(cat /etc/zarf-state/state | jq -r '.gitServer.pushPassword')

#####
# Upload all the PyPI packages
#####
python3 -m twine upload --repository-url=https://github.com/uploading/a/pypi \
                       -u=redirector -p=replaces \
                       --skip-existing \
                       --verbose \
                       /packages/pypi/*  

#####
# Upload all the npm packages
#####
# Get a auth token for the npm repository
token_response=$(curl -H "Content-Type: application/json" -d '{"name":"token-for-me-please"}' -u ${ZARF_USER}:${ZARF_PASS} http://zarf-gitea-http.zarf.svc.cluster.local:3000/api/v1/users/${ZARF_USER}/tokens)
npm_token=$(echo $token_response | jq -r '.sha1')

# Set the npm credentials
npm config set cafile /etc/ssl/certs/ca-certificates.crt
npm config set registry https://github.com/uploading/a/npm/
npm config set -- "//github.com/uploading/a/npm/:_authToken" "$npm_token"

# Publish the npm package
for NPM_PACKAGE in /packages/npm/*; do
    npm publish $NPM_PACKAGE
done


#####
# Upload all the generic packages
#####
pushd /packages/generic
for FILE in *; do 
    curl -X PUT --upload-file $FILE https://github.com/uploading/a/generic/test_packcages/${FILE}/${FILE}
done
popd
