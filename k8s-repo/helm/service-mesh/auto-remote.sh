#!/bin/bash

echo "--------------------Install Remote Cluster 3--------------------"

kubectl --context="${CTX_CLUSTER3}" create namespace istio-system
kubectl --context="${CTX_CLUSTER3}" annotate namespace istio-system topology.istio.io/controlPlaneClusters=cluster1

kubectl --context="${CTX_CLUSTER3}" label namespace istio-system topology.istio.io/network=network1

helm install istio-base istio/base -n istio-system --set profile=remote --kube-context "${CTX_CLUSTER3}" --version 1.25.2
helm install istiod istio/istiod -n istio-system --set profile=remote -f values-cluster3.yaml --kube-context "${CTX_CLUSTER3}" --version 1.25.2

istioctl create-remote-secret \
    --context="${CTX_CLUSTER3}" \
    --name=cluster3 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"


helm install istio-eastwestgateway istio/gateway -n istio-system -f values-ingress3.yaml --kube-context "${CTX_CLUSTER3}" --version 1.25.2

echo "--------------------Install Remote Cluster 4--------------------"

kubectl --context="${CTX_CLUSTER4}" create namespace istio-system
kubectl --context="${CTX_CLUSTER4}" annotate namespace istio-system topology.istio.io/controlPlaneClusters=cluster2

kubectl --context="${CTX_CLUSTER4}" label namespace istio-system topology.istio.io/network=network2

helm install istio-base istio/base -n istio-system --set profile=remote --kube-context "${CTX_CLUSTER4}" --version 1.25.2
helm install istiod istio/istiod -n istio-system --set profile=remote -f values-cluster4.yaml --kube-context "${CTX_CLUSTER4}" --version 1.25.2

istioctl create-remote-secret \
    --context="${CTX_CLUSTER4}" \
    --name=cluster4 | \
    kubectl apply -f - --context="${CTX_CLUSTER2}"


helm install istio-eastwestgateway istio/gateway -n istio-system -f values-ingress4.yaml --kube-context "${CTX_CLUSTER4}" --version 1.25.2

echo "--------------------Install Remote Cluster 5--------------------"

kubectl --context="${CTX_CLUSTER5}" create namespace istio-system
kubectl --context="${CTX_CLUSTER5}" annotate namespace istio-system topology.istio.io/controlPlaneClusters=cluster1

kubectl --context="${CTX_CLUSTER5}" label namespace istio-system topology.istio.io/network=network1

helm install istio-base istio/base -n istio-system --set profile=remote --kube-context "${CTX_CLUSTER5}" --version 1.25.2
helm install istiod istio/istiod -n istio-system --set profile=remote -f values-cluster5.yaml --kube-context "${CTX_CLUSTER5}" --version 1.25.2

istioctl create-remote-secret \
    --context="${CTX_CLUSTER5}" \
    --name=cluster5 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"


helm install istio-eastwestgateway istio/gateway -n istio-system -f values-ingress5.yaml --kube-context "${CTX_CLUSTER5}" --version 1.25.2

echo "--------------------Secret Remote--------------------"

istioctl create-remote-secret \
    --context="${CTX_CLUSTER4}" \
    --name=cluster4 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"

istioctl create-remote-secret \
    --context="${CTX_CLUSTER3}" \
    --name=cluster3 | \
    kubectl apply -f - --context="${CTX_CLUSTER2}"

istioctl create-remote-secret \
    --context="${CTX_CLUSTER5}" \
    --name=cluster5 | \
    kubectl apply -f - --context="${CTX_CLUSTER2}"

kubectl create --context="${CTX_CLUSTER3}" namespace sample
kubectl create --context="${CTX_CLUSTER4}" namespace sample
kubectl create --context="${CTX_CLUSTER5}" namespace sample

kubectl label --context="${CTX_CLUSTER3}" namespace sample \
    istio-injection=enabled
kubectl label --context="${CTX_CLUSTER4}" namespace sample \
    istio-injection=enabled
kubectl label --context="${CTX_CLUSTER5}" namespace sample \
    istio-injection=enabled


kubectl apply --context="${CTX_CLUSTER3}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="${CTX_CLUSTER4}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="${CTX_CLUSTER5}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample


kubectl apply --context="${CTX_CLUSTER3}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l version=v1 -n sample

kubectl apply --context="${CTX_CLUSTER4}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l version=v2 -n sample

kubectl apply --context="${CTX_CLUSTER5}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l version=v2 -n sample


kubectl apply --context="${CTX_CLUSTER3}" \
    -f ~/istio-1.25.2/samples/curl/curl.yaml -n sample
kubectl apply --context="${CTX_CLUSTER4}" \
    -f ~/istio-1.25.2/samples/curl/curl.yaml -n sample
kubectl apply --context="${CTX_CLUSTER5}" \
    -f ~/istio-1.25.2/samples/curl/curl.yaml -n sample

echo "Waiting for 10 seconds before test....."
sleep 10

for i in {1..15}; do
    kubectl exec --context="${CTX_CLUSTER4}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER4}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done

echo "--------------------------------------------------------------"


for i in {1..15}; do
    kubectl exec --context="${CTX_CLUSTER3}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER3}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done

echo "--------------------------------------------------------------"

for i in {1..15}; do
    kubectl exec --context="${CTX_CLUSTER5}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER5}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done

echo "--------------------------------------------------------------"

