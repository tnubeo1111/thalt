#!/bin/bash

bash ./auto-certs.sh

kubectl --context="${CTX_CLUSTER1}" get namespace istio-system && \
kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network1

helm install istio-base istio/base -n istio-system --kube-context="${CTX_CLUSTER1}" --version 1.25.2

helm install istiod istio/istiod -n istio-system -f values-cluster1.yaml --kube-context "${CTX_CLUSTER1}" --version 1.25.2

helm install istio-eastwestgateway istio/gateway -n istio-system -f values-ingress1.yaml --kube-context "${CTX_CLUSTER1}" --version 1.25.2

kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f expose-service-1-2.yaml

kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f expose-istiod.yaml 
