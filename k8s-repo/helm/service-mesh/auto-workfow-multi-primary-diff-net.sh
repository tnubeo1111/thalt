#!/bin/bash

echo "----------Certs----------"

bash ./auto-certs.sh

echo "----------Install Cluster 1----------"

bash ./auto-install-cluster1.sh

echo "----------Install Cluster 2----------"

bash ./auto-install-cluster2.sh

echo "Waiting for 6 seconds before Connect....."
sleep 6

bash ./auto-connect-1-2.yaml

echo "----------Verify----------"

bash ./auto-verify-1-2.sh
