#!/bin/bash

./kiali-prepare-remote-cluster.sh --kiali-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER2}
./kiali-prepare-remote-cluster.sh --kiali-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER3}
./kiali-prepare-remote-cluster.sh --kiali-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER4}
./kiali-prepare-remote-cluster.sh --kiali-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER1} --remote-cluster-context ${CTX_CLUSTER5}
