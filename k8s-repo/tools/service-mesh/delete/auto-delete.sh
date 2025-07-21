#!/bin/bash

echo "------------------------------------------------------------------------------"

# ENV
DIR=/home/thanhtha/github/thalt/k8s-repo/helm/service-mesh/delete

echo "-----Auto delete ISTIO on ${CTX_CLUSTER1}------"

yes y | istioctl install --context="${CTX_CLUSTER1}" -f ${DIR}/cluster1.yaml
istioctl uninstall -y --purge --context="${CTX_CLUSTER1}"

# Xóa namespaces
echo "Deleting namespaces istio-system and sample..."
kubectl delete ns istio-system sample --context="${CTX_CLUSTER1}" --ignore-not-found=true

# Check deleting namespace
if [ $? -eq 0 ]; then
    echo "Waiting for namespaces to be fully deleted..."
    for ns in istio-system sample; do
        while kubectl get ns "$ns" --context="${CTX_CLUSTER1}" >/dev/null 2>&1; do
            echo "Namespace $ns still exists, waiting..."
            sleep 2
        done
        echo "Namespace $ns fully deleted."
    done

    # Create ns istio-system
    echo "Creating namespace istio-system..."
    kubectl create ns istio-system --context="${CTX_CLUSTER1}"
    if [ $? -eq 0 ]; then
        echo "Namespace istio-system created successfully."
    else
        echo "Error creating namespace istio-system."
        exit 1
    fi
else
    echo "Error initiating namespace deletion. Skipping creation."
    exit 1
fi

echo "-----Auto delete ISTIO on ${CTX_CLUSTER2}------"

yes y | istioctl install --context="${CTX_CLUSTER2}" -f ${DIR}/cluster2.yaml
istioctl uninstall -y --purge --context="${CTX_CLUSTER2}"
# Xóa namespaces
echo "Deleting namespaces istio-system and sample..."
kubectl delete ns istio-system sample --context="${CTX_CLUSTER2}" --ignore-not-found=true

# Check deleting namespace
if [ $? -eq 0 ]; then
    echo "Waiting for namespaces to be fully deleted..."
    for ns in istio-system sample; do
        while kubectl get ns "$ns" --context="${CTX_CLUSTER2}" >/dev/null 2>&1; do
            echo "Namespace $ns still exists, waiting..."
            sleep 2
        done
        echo "Namespace $ns fully deleted."
    done

    # Create ns istio-system
    echo "Creating namespace istio-system..."
    kubectl create ns istio-system --context="${CTX_CLUSTER2}"
    if [ $? -eq 0 ]; then
        echo "Namespace istio-system created successfully."
    else
        echo "Error creating namespace istio-system."
        exit 1
    fi
else
    echo "Error initiating namespace deletion. Skipping creation."
    exit 1
fi


echo "-----Auto delete ISTIO on ${CTX_CLUSTER3}------"

yes y | istioctl install --context="${CTX_CLUSTER3}" -f ${DIR}/cluster3.yaml
istioctl uninstall -y --purge --context="${CTX_CLUSTER3}"
# Xóa namespaces
echo "Deleting namespaces istio-system and sample..."
kubectl delete ns istio-system sample --context="${CTX_CLUSTER3}" --ignore-not-found=true

# Check deleting namespace
if [ $? -eq 0 ]; then
    echo "Waiting for namespaces to be fully deleted..."
    for ns in istio-system sample; do
        while kubectl get ns "$ns" --context="${CTX_CLUSTER3}" >/dev/null 2>&1; do
            echo "Namespace $ns still exists, waiting..."
            sleep 2
        done
        echo "Namespace $ns fully deleted."
    done

    # Create ns istio-system
    echo "Creating namespace istio-system..."
    kubectl create ns istio-system --context="${CTX_CLUSTER3}"
    if [ $? -eq 0 ]; then
        echo "Namespace istio-system created successfully."
    else
        echo "Error creating namespace istio-system."
        exit 1
    fi
else
    echo "Error initiating namespace deletion. Skipping creation."
    exit 1
fi


echo "-----Auto delete ISTIO on ${CTX_CLUSTER4}------"

yes y | istioctl install --context="${CTX_CLUSTER4}" -f ${DIR}/cluster4.yaml
istioctl uninstall -y --purge --context="${CTX_CLUSTER4}"
# Xóa namespaces
echo "Deleting namespaces istio-system and sample..."
kubectl delete ns istio-system sample --context="${CTX_CLUSTER4}" --ignore-not-found=true

# Check deleting namespace
if [ $? -eq 0 ]; then
    echo "Waiting for namespaces to be fully deleted..."
    for ns in istio-system sample; do
        while kubectl get ns "$ns" --context="${CTX_CLUSTER4}" >/dev/null 2>&1; do
            echo "Namespace $ns still exists, waiting..."
            sleep 2
        done
        echo "Namespace $ns fully deleted."
    done

    # Create ns istio-system
    echo "Creating namespace istio-system..."
    kubectl create ns istio-system --context="${CTX_CLUSTER4}"
    if [ $? -eq 0 ]; then
        echo "Namespace istio-system created successfully."
    else
        echo "Error creating namespace istio-system."
        exit 1
    fi
else
    echo "Error initiating namespace deletion. Skipping creation."
    exit 1
fi

echo "------------------------------------------------------------------------------"


echo "-----Auto delete ISTIO on ${CTX_CLUSTER5}------"

yes y | istioctl install --context="${CTX_CLUSTER5}" -f ${DIR}/cluster5.yaml
istioctl uninstall -y --purge --context="${CTX_CLUSTER5}"

# Xóa namespaces
echo "Deleting namespaces istio-system and sample..."
kubectl delete ns istio-system sample --context="${CTX_CLUSTER5}" --ignore-not-found=true

# Check deleting namespace
if [ $? -eq 0 ]; then
    echo "Waiting for namespaces to be fully deleted..."
    for ns in istio-system sample; do
        while kubectl get ns "$ns" --context="${CTX_CLUSTER5}" >/dev/null 2>&1; do
            echo "Namespace $ns still exists, waiting..."
            sleep 2
        done
        echo "Namespace $ns fully deleted."
    done

    # Create ns istio-system
    echo "Creating namespace istio-system..."
    kubectl create ns istio-system --context="${CTX_CLUSTER5}"
    if [ $? -eq 0 ]; then
        echo "Namespace istio-system created successfully."
    else
        echo "Error creating namespace istio-system."
        exit 1
    fi
else
    echo "Error initiating namespace deletion. Skipping creation."
    exit 1
fi

