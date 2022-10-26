#!/bin/bash

# Update CA Certs that were potentially volumed into the pod
update-ca-certificates

# Set the profile environment variables
cat <<EOF >> /root/.bashrc
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export TWINE_CERT=/etc/ssl/certs/ca-certificates.crt
EOF

# Set the npm certificate
npm config set cafile /etc/ssl/certs/ca-certificates.crt

tail -f /dev/null
