#!/bin/bash


kubectl create --context="${CTX_CLUSTER1}" namespace sample
kubectl create --context="${CTX_CLUSTER2}" namespace sample

kubectl label --context="${CTX_CLUSTER1}" namespace sample \
    istio-injection=enabled
kubectl label --context="${CTX_CLUSTER2}" namespace sample \
    istio-injection=enabled


kubectl apply --context="${CTX_CLUSTER1}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample


kubectl apply --context="${CTX_CLUSTER1}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l version=v1 -n sample

kubectl apply --context="${CTX_CLUSTER2}" \
    -f ~/istio-1.25.2/samples/helloworld/helloworld.yaml \
    -l version=v2 -n sample


kubectl apply --context="${CTX_CLUSTER1}" \
    -f ~/istio-1.25.2/samples/curl/curl.yaml -n sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f ~/istio-1.25.2/samples/curl/curl.yaml -n sample

echo "Waiting for 10 seconds before test....."
sleep 10

for i in {1..20}; do
    kubectl exec --context="${CTX_CLUSTER2}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER2}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done

echo "Test Done !!!... Delete Namespace sample....."
kubectl delete ns sample --context="${CTX_CLUSTER1}"
kubectl delete ns sample --context="${CTX_CLUSTER2}"
