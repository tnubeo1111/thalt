#!/bin/bash

kubectl --context="${CTX_CLUSTER2}" get namespace istio-system && \
kubectl --context="${CTX_CLUSTER2}" label namespace istio-system topology.istio.io/network=network2

helm install istio-base istio/base -n istio-system --kube-context="${CTX_CLUSTER2}" --version 1.25.2

helm install istiod istio/istiod -n istio-system -f values-cluster2.yaml --kube-context "${CTX_CLUSTER2}" --version 1.25.2

helm install istio-eastwestgateway istio/gateway -n istio-system -f values-ingress2.yaml --kube-context "${CTX_CLUSTER2}" --version 1.25.2

kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f expose-service-1-2.yaml

kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f expose-istiod.yaml

echo "--------------Connect Cluster 1 & Cluster 2-----------------"
