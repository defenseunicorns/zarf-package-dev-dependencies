#!/bin/bash

set -e

# Cleanup any previous runs
rm -rf zarf-package-dev-dependencies

# Test git cloning inside of the build container
git clone https://github.com/defenseunicorns/zarf-package-dev-dependencies.git
cd zarf-package-dev-dependencies/src

# Test generic registries
pushd generic

./index.sh

popd

# Test generic registries
pushd node

# TODO (@WSTARR) Remove once we update Gitea to 1.17.4
rm package-lock.json
npm install
./index.js

popd

# Test generic registries
pushd python

pip install -r requirements.txt
./index.py

popd
