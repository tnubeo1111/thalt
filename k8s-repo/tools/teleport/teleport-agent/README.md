# Teleport Agent Deployment Guide

This guide provides step-by-step instructions for deploying the Teleport agent in a Kubernetes cluster to provide access to applications and databases.

## Prerequisites

- `kubectl` installed and configured to connect to your Kubernetes cluster.
- `helm` v3 installed.
- Access to a running Teleport cluster and the `tctl` admin tool.

## Step 1: Create Namespace

All resources for the Teleport agent will be deployed in the `teleport-agent` namespace.

```bash
kubectl create namespace teleport-agent
```

## Step 2: Configure RBAC for Teleport Server

For the Kubernetes join method to work, the main Teleport server needs permission to review tokens. Apply the following RBAC configuration to your cluster. This allows the `teleport-sa` service account in the `teleport` namespace to create `tokenreviews`.

```bash
kubectl apply -f ./token/teleport-server-rbac.yaml
```

## Step 3: Create a Common Service Account for Agents

We will use a single, dedicated service account for all Teleport agents (app, db, etc.) to simplify permissions management.

```bash
kubectl create sa teleport-full-service -n teleport-agent
```

## Step 4: Configure RBAC for the Teleport Agent

The agent's service account needs permission to read secrets within its own namespace to function correctly.

```bash
kubectl apply -f ./token/agent-secret-access.yaml
```

## Step 5: Create the Teleport Provisioning Token

Create a provisioning token on your Teleport cluster. This token is configured to allow agents using the `teleport-full-service` service account to join the cluster.

**Note:** You will need to `exec` into your Teleport auth server pod to run this command. Adjust the pod name and namespace as necessary.

```bash
kubectl exec -i -n teleport <teleport-auth-pod-name> -- tctl create -f - < ./token/token-roles-app.yaml
```

## Step 6: Deploy the Teleport Agents via Helm

With the prerequisites in place, you can now deploy the agents using Helm.

**Important:** When deploying multiple agents in the same namespace using the Helm chart, ensure that the `joinTokenSecret.name` value is unique for each release if `joinTokenSecret.create` is set to `true`. This prevents conflicts between Helm releases.

### App Agent

The App Agent provides access to internal web applications.

1.  Review the configuration in `agent-app/agent-teleport-values.yaml`. Ensure the `serviceAccount.name`, `joinParams.tokenName`, and `joinTokenSecret.name` are correctly configured.
2.  Install or upgrade the Helm release.

```bash
# Add the Teleport Helm repository if you haven't already
helm repo add teleport https://charts.releases.teleport.dev/

# Install or upgrade the agent
helm upgrade --install teleport-agent-app teleport/teleport-kube-agent \
  --namespace teleport-agent \
  -f ./agent-app/agent-teleport-values.yaml
```

### Database Agent

The Database Agent provides access to databases.

1.  Review the configuration in `agent-db/agent-teleport-db-values.yaml`. Ensure the `joinParams.method` is set to `kubernetes` and that `joinTokenSecret.name` is unique.
2.  Install or upgrade the Helm release.

```bash
helm upgrade --install teleport-agent-db teleport/teleport-kube-agent \
  --namespace teleport-agent \
  -f ./agent-db/agent-teleport-db-values.yaml
```

## Step 7: Verify the Deployment

Check the status of the pods in the `teleport-agent` namespace. They should be in the `Running` state.

```bash
kubectl get pods -n teleport-agent
```

You can also check the logs to ensure the agents have successfully connected to the Teleport cluster.

```bash
kubectl logs -n teleport-agent -l app.kubernetes.io/name=teleport-kube-agent
```