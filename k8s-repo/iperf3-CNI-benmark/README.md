# Kubernetes CNI Benchmark With iPerf3


To compare the network performance between Calico and Cilium in your Kubernetes cluster, you can follow these steps:

1. Prepare your Kubernetes Cluster:

    * Ensure your Kubernetes cluster is properly set up and running with Calico as the CNI.
    * Verify that you have admin access to your cluster.

2. Deploy a Network Performance Benchmarking Tool:

You can use tools like `iperf`, `netperf`, or `wrk` to measure network performance.
`iperf` is commonly used and can be deployed as a pod in your cluster to measure throughput between nodes.

3. Benchmark with Calico:

    * Deploy iPerf3 pods in your cluster.
    * Run network performance tests and collect data.

4. Migrate from Calico to Cilium:

    * Safely migrate your CNI from Calico to Cilium.
    * Ensure your applications and services are running smoothly after the migration.

5. Benchmark with Cilium:

    * Repeat the deployment of iperf pods and run the same network performance tests.
    * Collect data for comparison.


## Using iperf3-to-influxdb and Grafana

### Step 1: Create InfluxDB   And iperf Database

Deploy InfluxDB in your Kubernetes cluster: `influxdb.yaml`

```shell
kubectl apply -f influxdb.yaml
# create database
kubectl exec -it deploy/influxdb -- influx -execute 'CREATE DATABASE iperf'
# list databases
kubectl exec -it deploy/influxdb -- influx -execute 'SHOW DATABASES'
```

### Step 2: Create the iperf3 Server Deployment and Service

Ensure the iperf server is running and accessible as described earlier: `iperf-server.yaml`

`kubectl apply -f iperf-server.yaml`


### Step 3: Create the ConfigMap for the Script

Create a ConfigMap that contains the iperf-to-influx.sh script: `iperf-to-influx-configmap.yaml`

`kubectl apply -f iperf-to-influx-configmap.yaml`


### Step 4: Create a CronJob to Schedule the Parallel Job

Create a CronJob that schedules the above Job template periodically: `iperf-client-cronjob.yaml`

`kubectl apply -f iperf-client-cronjob.yaml`


### Step 5: Visualize Data in Grafana

Create  datasource in grafana namespace

```shell
## EDIT grafana-datasource.yaml  to Update influxdb namespace by replacing: YOUR_NAMESPACE

kubectl create -f grafana-datasource.yaml  -n monitoring

kubectl create cm iperf-dashboard --from-file=grafana-dashboard.json && kubectl label configmap/iperf-dashboard grafana_dashboard="1"

```
