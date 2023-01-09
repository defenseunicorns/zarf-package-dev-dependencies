#!/bin/bash

# Install kubectl from "dl.k8s.io"
RELEASE=$(curl -L -s https://dl.k8s.io/release/stable.txt)
echo "Installing Version $RELEASE"
curl -LO https://dl.k8s.io/release/$RELEASE/bin/linux/amd64/kubectl
curl -LO https://dl.k8s.io/$RELEASE/bin/linux/amd64/kubectl.sha256
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
