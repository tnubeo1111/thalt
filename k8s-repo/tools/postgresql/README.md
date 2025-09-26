# PostgreSQL on Kubernetes with TLS/SSL & Client Certificates (End‑to‑End Guide)

This README walks you from zero to a working PostgreSQL on Kubernetes that:
- encrypts traffic with TLS,
- **requires client certificates** (mTLS on the client side), and
- uses your provided manifests.

It also includes verification, troubleshooting, and rotation steps.

---

## Contents
1. [Prerequisites](#prerequisites)
2. [Repository Layout](#repository-layout)
3. [Create Namespace](#create-namespace)
4. [Generate Certificates](#generate-certificates)
   - [4.1 Root CA](#41-root-ca)
   - [4.2 Server Certificate (with SAN)](#42-server-certificate-with-san)
   - [4.3 Client Certificate](#43-client-certificate)
5. [Create Kubernetes Secrets](#create-kubernetes-secrets)
6. [Create DB Credential Secret](#create-db-credential-secret)
7. [Provision Storage (PV/PVC)](#provision-storage-pvpvc)
8. [Deploy PostgreSQL (StatefulSet + Service)](#deploy-postgresql-statefulset--service)
9. [Test the TLS/Client‑Cert Connection](#test-the-tlsclientcert-connection)
10. [Optional: Enforce Client‑Cert Auth via pg_hba.conf + pg_ident.conf](#optional-enforce-clientcert-auth-via-pg_hbaconf--pg_identconf)
11. [Certificate Rotation (No/Low Downtime)](#certificate-rotation-nolow-downtime)
12. [Troubleshooting](#troubleshooting)
13. [Hardening Tips](#hardening-tips)
14. [Quick Start (All Commands)](#quick-start-all-commands)

---

## Prerequisites
- A running Kubernetes cluster. For **hostPath** PV, this is typically a single‑node/dev cluster.
- `kubectl` installed and configured against the cluster.
- OpenSSL installed on your workstation (or any host where you generate certs).
- The following files already exist in this repository:
  - `1-postgresql-pv-pvc.yaml`
  - `3-postgresql-secret.yaml`
  - `4-postgresql-statefulset.yaml`
  - `5-postgresql-service.yaml`
- You will create two TLS secrets at runtime:
  - `postgresql-tls` (server cert/key + root CA)
  - `postgresql-tls-client` (client cert/key + root CA)

> **Note on image & UID**: The manifests use image `bitnamisecure/postgresql` and run the server as UID `26`. The initContainer copies TLS materials from a Secret into an `emptyDir`, fixes ownership to `26:26`, and sets the private key to `0600` — this is mandatory for PostgreSQL to accept the key.

---

## Repository Layout
```
1-postgresql-pv-pvc.yaml        # PV/PVC (hostPath, dev/lab usage)
3-postgresql-secret.yaml        # DB user/password/database secrets (Base64 values)
4-postgresql-statefulset.yaml   # StatefulSet (TLS enabled via env), initContainers for perms
5-postgresql-service.yaml       # Headless Service for the StatefulSet
```

---

## Create Namespace
```bash
kubectl create namespace postgresql
```
> Use `-n postgresql` for all subsequent `kubectl` commands so objects live in the same namespace.

---

## Generate Certificates
You need a **Root CA**, a **server certificate** (for Postgres), and a **client certificate** (for applications/psql).

### 4.1 Root CA
```bash
# Root CA private key (keep this safe!)
openssl genrsa -out rootCA.key 4096

# Self-signed Root CA certificate (valid ~10 years)
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 \
  -subj "/C=VN/ST=HCM/O=YourOrg/CN=YourPostgresRootCA" \
  -out rootCA.crt
```

### 4.2 Server Certificate (with SAN)
Create `server-san.cnf` with proper DNS entries matching your Kubernetes Service (adjust if you rename):
```ini
# server-san.cnf
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
C=VN
ST=HCM
O=YourOrg
CN=postgres.postgresql.svc.cluster.local

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = postgres
DNS.2 = postgres.postgresql.svc
DNS.3 = postgres.postgresql.svc.cluster.local
```
Generate key/CSR and sign with your Root CA:
```bash
# Server key
openssl genrsa -out server.key 2048

# CSR using SAN config
openssl req -new -key server.key -out server.csr -config server-san.cnf

# Sign CSR with Root CA
openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -out server.crt -days 825 -sha256 -extfile server-san.cnf -extensions req_ext

# Enforce strict permissions for the private key
chmod 600 server.key
```

### 4.3 Client Certificate
Create `client.cnf` to mark the cert for **clientAuth**:
```ini
# client.cnf
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = v3_req

[ dn ]
C=VN
ST=HCM
O=YourOrg
CN=teleport            # CN will be mapped to a DB role; keep it simple

[ v3_req ]
extendedKeyUsage = clientAuth
keyUsage = digitalSignature
```
Generate and sign:
```bash
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -config client.cnf
openssl x509 -req -in client.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -out client.crt -days 365 -sha256 -extfile client.cnf -extensions v3_req

chmod 600 client.key
```

---

## Create Kubernetes Secrets
Create the **server‑side** TLS secret (used by PostgreSQL Pod) and the **client‑side** TLS secret (for app Pods/psql):
```bash
# Server TLS (for the StatefulSet)
kubectl -n postgresql create secret generic postgresql-tls \
  --from-file=server.crt=./server.crt \
  --from-file=server.key=./server.key \
  --from-file=rootCA.crt=./rootCA.crt

# Client TLS (for applications/psql pods)
kubectl -n postgresql create secret generic postgresql-tls-client \
  --from-file=client.crt=./client.crt \
  --from-file=client.key=./client.key \
  --from-file=rootCA.crt=./rootCA.crt
```

> Do **not** mount the client secret into the Postgres server — it belongs to clients only.

---

## Create DB Credential Secret
Apply your credentials secret:
```bash
kubectl -n postgresql apply -f 3-postgresql-secret.yaml
```
Keys inside are Base64 encoded values for:
- `POSTGRESQL_USERNAME`
- `POSTGRESQL_PASSWORD`
- `POSTGRESQL_DATABASE`
- `POSTGRESQL_POSTGRES_PASSWORD`

---

## Provision Storage (PV/PVC)
Apply the hostPath PV/PVC (dev/lab usage):
```bash
kubectl -n postgresql apply -f 1-postgresql-pv-pvc.yaml
```
Confirm it’s bound:
```bash
kubectl -n postgresql get pvc
# Expect: postgres-pvc → Bound to postgres-pv
```
> For production, replace hostPath with a proper StorageClass (Ceph RBD, EBS, etc.).

---

## Deploy PostgreSQL (StatefulSet + Service)
Apply the StatefulSet and Service:
```bash
kubectl -n postgresql apply -f 4-postgresql-statefulset.yaml
kubectl -n postgresql apply -f 5-postgresql-service.yaml
```
Watch rollout and logs:
```bash
kubectl -n postgresql rollout status sts/postgres
kubectl -n postgresql get pods -l app=postgres -w
kubectl -n postgresql logs -f sts/postgres
```
The StatefulSet does the following:
- Enables TLS via env vars (`POSTGRESQL_ENABLE_TLS=yes`, paths under `/tls`).
- Copies server certs from `Secret → emptyDir` and fixes ownership/perms (`server.key` must be `0600`).
- `chown`s the data dir to UID `26`.

---

## Test the TLS/Client‑Cert Connection
### Option A: From an in‑cluster temporary client pod
Create a psql client pod that mounts the client TLS secret:
```bash
kubectl -n postgresql run psql-client --rm -it \
  --image=bitnami/postgresql:16 \
  --overrides='{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {"name":"psql-client"},
    "spec": {
      "containers": [{
        "name": "psql-client",
        "image": "bitnami/postgresql:16",
        "command": ["sleep","infinity"],
        "volumeMounts": [{"name":"tls","mountPath":"/tls","readOnly":true}]
      }],
      "volumes": [{"name":"tls","secret":{"secretName":"postgresql-tls-client"}}]
    }
  }' -- bash
```
Run `psql` with **verify‑full** and client certs:
```bash
psql "host=postgres.postgresql.svc user=teleport dbname=teleport \
      sslmode=verify-full sslrootcert=/tls/rootCA.crt \
      sslcert=/tls/client.crt sslkey=/tls/client.key"
```
Verify inside psql:
```sql
SHOW ssl;                          -- should be on
SELECT * FROM pg_stat_ssl WHERE pid = pg_backend_pid();
SELECT current_user;               -- should reflect the mapped DB role
```

### Option B: From your workstation (port‑forward)
```bash
kubectl -n postgresql port-forward svc/postgres 5432:5432

psql "host=localhost user=teleport dbname=teleport \
      sslmode=verify-full sslrootcert=./rootCA.crt \
      sslcert=./client.crt sslkey=./client.key"
```

---

## Certificate Rotation (No/Low Downtime)
1. Issue new certs (and optionally a new CA). If you change the CA, create a **bundle** `rootCA.crt` containing both old and new CAs during the migration window.
2. Create a **new** server secret (e.g. `postgresql-tls-v2`).
3. Update the StatefulSet to reference the new secret and apply.
4. Roll the StatefulSet **gradually** (one Pod at a time if running multiple replicas).
5. For clients, distribute a new `postgresql-tls-client-v2` secret and update Deployments in batches.

---

## Troubleshooting
- **`FATAL: connection requires a valid client certificate`**  
  You attempted to connect without `sslcert`/`sslkey` while server is configured to require client cert. Add them to the connection string.

- **SAN / hostname mismatch with `sslmode=verify-full`**  
  Ensure the server certificate includes your Service DNS names in SAN (e.g., `postgres.postgresql.svc`, `postgres.postgresql.svc.cluster.local`). Reissue and rotate if missing.

- **`server.key` permissions error**  
  The private key must be owned by the Postgres user and `0600`. The initContainer in the StatefulSet already enforces this. If you change paths/users, re‑check ownership and mode.

- **PVC not bound**  
  For `hostPath`, ensure the path exists on the node and you’re on a single‑node/dev setup. For production, switch to a StorageClass provisioner.

---

## Hardening Tips
- Set `ssl_min_protocol_version = 'TLSv1.2'` (or `TLSv1.3` if all clients support it).
- Narrow IPs in `pg_hba.conf` instead of `0.0.0.0/0`.
- Add NetworkPolicies to restrict which namespaces/pods can reach port 5432.
- Use least‑privilege DB roles; avoid using `postgres` for applications.

---

## Quick Start (All Commands)
```bash
# 1) Namespace
kubectl create namespace postgresql

# 2) TLS Secrets (server + client)
kubectl -n postgresql create secret generic postgresql-tls \
  --from-file=server.crt=./server.crt \
  --from-file=server.key=./server.key \
  --from-file=rootCA.crt=./rootCA.crt

kubectl -n postgresql create secret generic postgresql-tls-client \
  --from-file=client.crt=./client.crt \
  --from-file=client.key=./client.key \
  --from-file=rootCA.crt=./rootCA.crt

# 3) DB credential Secret
kubectl -n postgresql apply -f 3-postgresql-secret.yaml

# 4) Storage
kubectl -n postgresql apply -f 1-postgresql-pv-pvc.yaml

# 5) StatefulSet & Service
kubectl -n postgresql apply -f 4-postgresql-statefulset.yaml
kubectl -n postgresql apply -f 5-postgresql-service.yaml

# 6) Verify rollout
kubectl -n postgresql rollout status sts/postgres
kubectl -n postgresql get pods -l app=postgres -w

# 7) Test (client pod)
kubectl -n postgresql run psql-client --rm -it \
  --image=bitnami/postgresql:16 \
  --overrides='{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {"name":"psql-client"},
    "spec": {
      "containers": [{
        "name": "psql-client",
        "image": "bitnami/postgresql:16",
        "command": ["sleep","infinity"],
        "volumeMounts": [{"name":"tls","mountPath":"/tls","readOnly":true}]
      }],
      "volumes": [{"name":"tls","secret":{"secretName":"postgresql-tls-client"}}]
    }
  }' -- bash

psql "host=postgres.postgresql.svc user=teleport dbname=teleport \
      sslmode=verify-full sslrootcert=/tls/rootCA.crt \
      sslcert=/tls/client.crt sslkey=/tls/client.key"
```

