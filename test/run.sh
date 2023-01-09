#!/bin/bash

POD=$(kubectl get pods -l app=package-registry-build -n zarf --output=jsonpath={.items..metadata.name})
TEST_PATH=$(dirname "$0")

while [[ "$(kubectl exec $POD -n zarf -- curl -s -o /dev/null -w ''%{http_code}'' https://github.com/.done.txt)" != "200" ]]; do
    echo "Waiting for deployment completion"
    sleep 5
done

kubectl cp -n zarf $TEST_PATH/test.sh $POD:/test.sh
kubectl exec $POD -n zarf -- /test.sh
