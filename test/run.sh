#!/bin/bash

POD=$(kubectl get pods -l app=package-registry-build -n zarf --output=jsonpath={.items..metadata.name})
TEST_PATH=$(dirname "$0")

kubectl cp -n zarf $TEST_PATH/test.sh $POD:/test.sh
kubectl exec $POD -n zarf -- /test.sh
