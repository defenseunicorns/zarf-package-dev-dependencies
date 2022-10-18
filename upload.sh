#!/bin/bash

# Update CA Certs that were potentially volumed into the pod
update-ca-certificates

export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

#####
# Upload all the PyPI packages
#####
python3 -m twine upload --repository-url=https://${GITEA_URL}/api/packages/${ZARF_USER}/pypi \
                       -u=${ZARF_USER} -p=${ZARF_PASS} \
                       --skip-existing \
                       --verbose \
                       /packages/pypi/*  


#####
# Upload all the npm packages
#####
# Get a auth token for the npm repository
token_response=$(curl -H "Content-Type: application/json" -d '{"name":"token-f-meplase"}' -u ${ZARF_USER}:${ZARF_PASS} https://${GITEA_URL}/api/v1/users/${ZARF_USER}/tokens)
npm_token=$(echo $token_response | jq -r '.sha1')

# Set the npm credentials
npm config set cafile /etc/ssl/certs/ca-certificates.crt
npm config set registry https://${GITEA_URL}/api/packages/${ZARF_USER}/npm/
npm config set -- "//${GITEA_URL}/api/packages/zarf-git-user/npm/:_authToken" "$npm_token"

# Publish the npm package
for NPM_PACKAGE in /packages/npm/*; do
    npm publish $NPM_PACKAGE
done


#####
# Upload all the generic packages
#####
pushd /packages/generic
for FILE in *; do 
    curl -X PUT --user ${ZARF_USER}:${ZARF_PASS} --upload-file $FILE https://${GITEA_URL}/api/packages/${ZARF_USER}/generic/test_packcages/${FILE}/${FILE}
done
popd
