#/bin/bash

for i in {1..20}; do
    kubectl exec --context="${CTX_CLUSTER4}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER4}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done


for i in {1..20}; do
    kubectl exec --context="${CTX_CLUSTER3}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER3}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done


for i in {1..20}; do
    kubectl exec --context="${CTX_CLUSTER5}" -n sample -c curl \
        "$(kubectl get pod --context="${CTX_CLUSTER5}" -n sample -l \
        app=curl -o jsonpath='{.items[0].metadata.name}')" \
        -- curl -sS helloworld.sample:5000/hello
done

