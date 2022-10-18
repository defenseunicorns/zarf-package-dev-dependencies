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
python3 -m twine upload --repository-url=https://github.com/uploading/a/pypi \
                       -u=redirector -p=replaces \
                       --skip-existing \
                       --verbose \
                       /packages/pypi/*  

# Set the npm credentials
npm config set cafile /etc/ssl/certs/ca-certificates.crt
npm config set registry https://github.com/uploading/a/npm/
NPM_TOKEN="62db174df522aab21078c1f67c228f52e9ce24f7"
npm config set -- "//github.com/uploading/a/npm/:_authToken" "62db174df522aab21078c1f67c228f52e9ce24f7"

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
