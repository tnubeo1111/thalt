# PostgreSQL Monitoring with Prometheus Exporter

## 📋 Overview

This project provides a comprehensive PostgreSQL database monitoring solution on Kubernetes using Prometheus and corresponding exporters. The system includes:

- **PostgreSQL Exporter**: Collects metrics from PostgreSQL database
- **Node Exporter**: Collects metrics from server/node infrastructure
- **ServiceMonitor**: Configures Prometheus Operator for metrics scraping
- **Service & Endpoints**: Exposes metrics endpoints for collection

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │  Node Exporter  │    │   Prometheus    │
│    Database     │    │   (Server)      │    │    Server       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │ PG Exporter     │    │ Node Exporter   │    │ ServiceMonitor  │
    │ (Deployment)    │    │ Service         │    │ (Scraping)      │
    └─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📁 Directory Structure

```
k8s-repo/tools/postgresql/exporter/
├── exporter-db/
│   ├── pg-exporter-deploy.yaml           # PostgreSQL Exporter Deployment
│   └── pg-exporter-servicemonitor.yaml   # ServiceMonitor for PG metrics
└── exporter-server/
    ├── postgresql-node-exporter-service-dummy.yaml    # Node Exporter Service
    ├── postgresql-node-exporter-endpoints.yaml        # Endpoints configuration  
    └── postgresql-node-exporter-servicemonitor.yaml   # ServiceMonitor for Node metrics
```

## 🚀 Deployment

### Step 1: Deploy PostgreSQL Exporter

```bash
# Deploy PostgreSQL Exporter
kubectl apply -f exporter-db/pg-exporter-deploy.yaml

# Deploy ServiceMonitor for PostgreSQL metrics
kubectl apply -f exporter-db/pg-exporter-servicemonitor.yaml
```

### Step 2: Deploy Node Exporter

```bash
# Deploy Node Exporter Service
kubectl apply -f exporter-server/postgresql-node-exporter-service-dummy.yaml

# Deploy Endpoints
kubectl apply -f exporter-server/postgresql-node-exporter-endpoints.yaml  

# Deploy ServiceMonitor for Node metrics
kubectl apply -f exporter-server/postgresql-node-exporter-servicemonitor.yaml
```

### Step 3: Deploy All Components

```bash
# Deploy all components at once
kubectl apply -f exporter-db/
kubectl apply -f exporter-server/
```

## 🔧 Configuration

### PostgreSQL Exporter Configuration

The PostgreSQL Exporter requires the following environment variables:

```yaml
env:
  - name: DATA_SOURCE_NAME
    value: "postgresql://username:password@postgres-host:5432/database?sslmode=disable"
  - name: PG_EXPORTER_WEB_LISTEN_ADDRESS
    value: ":9187"
  - name: PG_EXPORTER_EXTEND_QUERY_PATH
    value: "/etc/postgres_exporter/queries.yaml"
```

### Node Exporter Configuration

Node Exporter typically runs on each node and exposes metrics on port `9100`:

```yaml
ports:
  - name: metrics
    port: 9100
    protocol: TCP
    targetPort: 9100
```

## 📊 Metrics

### PostgreSQL Metrics

The PostgreSQL Exporter provides essential database metrics:

#### Database Health & Connectivity
- **pg_up**: Database availability status (1 = up, 0 = down)
- **pg_database_size_bytes**: Size of each database in bytes
- **pg_stat_database_***: Comprehensive database statistics

#### Performance Metrics
- **pg_stat_user_tables_***: Table-level statistics (scans, inserts, updates, deletes)
- **pg_stat_user_indexes_***: Index usage and efficiency metrics
- **pg_stat_bgwriter_***: Background writer process statistics
- **pg_stat_archiver_***: WAL archiving statistics

#### Connection & Session Metrics
- **pg_stat_database_numbackends**: Number of active connections per database
- **pg_settings_max_connections**: Maximum allowed connections
- **pg_locks_***: Lock information and contention metrics

#### Replication Metrics
- **pg_stat_replication_***: Replication lag and status
- **pg_stat_wal_receiver_***: WAL receiver statistics

### Node/Server Metrics

Node Exporter provides infrastructure metrics:

#### System Resources
- **node_cpu_***: CPU usage, idle time, and load metrics
- **node_memory_***: Memory usage, available, and swap metrics  
- **node_filesystem_***: Disk usage, available space, and inode metrics
- **node_load***: System load averages (1m, 5m, 15m)

#### Network & I/O
- **node_network_***: Network interface statistics and errors
- **node_disk_***: Disk I/O operations and timing
- **node_netstat_***: Network connection statistics

## 🔍 Monitoring & Troubleshooting

### Health Checks

```bash
# Check PostgreSQL Exporter pods status
kubectl get pods -l app=pg-exporter -o wide

# View PostgreSQL Exporter logs  
kubectl logs -l app=pg-exporter --tail=100

# Check all exporter services
kubectl get svc | grep exporter

# Verify ServiceMonitor resources
kubectl get servicemonitor -A
```

### Metrics Validation

```bash
# Port forward to check PostgreSQL metrics
kubectl port-forward svc/pg-exporter-service 9187:9187

# Access PostgreSQL metrics endpoint
curl http://localhost:9187/metrics | grep pg_up

# Port forward for node metrics (if applicable)
kubectl port-forward svc/node-exporter-service 9100:9100
curl http://localhost:9100/metrics | grep node_load1
```

### ServiceMonitor Validation

```bash
# Check ServiceMonitor configuration
kubectl get servicemonitor pg-exporter-servicemonitor -o yaml

# Verify labels match service selectors
kubectl describe servicemonitor pg-exporter-servicemonitor

# Check Prometheus targets (if Prometheus is accessible)
kubectl port-forward svc/prometheus-service 9090:9090
# Visit http://localhost:9090/targets
```

## 📋 Requirements

### Prerequisites

1. **Kubernetes Cluster**: Version 1.16+
2. **Prometheus Operator**: Required for ServiceMonitor CRD support
3. **PostgreSQL Database**: Target database for monitoring
4. **RBAC Permissions**: Appropriate cluster roles for metric collection

### Recommended Resource Allocation

```yaml
# PostgreSQL Exporter Resources
resources:
  requests:
    memory: "64Mi"
    cpu: "50m"
  limits:
    memory: "128Mi" 
    cpu: "100m"

# Node Exporter Resources  
resources:
  requests:
    memory: "32Mi"
    cpu: "25m"
  limits:
    memory: "64Mi"
    cpu: "50m"
```

### Network Requirements

- **PostgreSQL**: Port 5432 accessible from exporter pods
- **Metrics Endpoints**: Ports 9187 (PG) and 9100 (Node) for Prometheus scraping
- **DNS Resolution**: Service discovery must work within cluster

## 🔐 Security Configuration

### Database User Setup

Create a dedicated monitoring user with minimal required privileges:

```sql
-- Create monitoring user
CREATE USER postgres_exporter WITH PASSWORD 'secure_random_password';

-- Grant connection permissions
GRANT CONNECT ON DATABASE your_database TO postgres_exporter;
GRANT USAGE ON SCHEMA public TO postgres_exporter;

-- Grant read permissions on tables and sequences
GRANT SELECT ON ALL TABLES IN SCHEMA public TO postgres_exporter;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres_exporter;

-- Grant access to system statistics views
GRANT SELECT ON pg_stat_database TO postgres_exporter;
GRANT SELECT ON pg_stat_user_tables TO postgres_exporter;
GRANT SELECT ON pg_stat_user_indexes TO postgres_exporter;
GRANT SELECT ON pg_stat_bgwriter TO postgres_exporter;
GRANT SELECT ON pg_stat_replication TO postgres_exporter;
GRANT SELECT ON pg_locks TO postgres_exporter;

-- For PostgreSQL 10+, grant monitoring role
GRANT pg_monitor TO postgres_exporter;
```

### Kubernetes RBAC

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: postgres-exporter
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: postgres-exporter
rules:
- apiGroups: [""]
  resources: ["nodes", "nodes/metrics", "services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: postgres-exporter
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: postgres-exporter
subjects:
- kind: ServiceAccount
  name: postgres-exporter
  namespace: monitoring
```

### Secrets Management

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-exporter-secret
  namespace: monitoring
type: Opaque
stringData:
  DATA_SOURCE_NAME: "postgresql://postgres_exporter:secure_password@postgres-service:5432/mydatabase?sslmode=require"
```

## 📈 Dashboards & Alerting

### Grafana Dashboard Integration

Import these popular community dashboards:

1. **PostgreSQL Database Overview**
   - Dashboard ID: `9628`
   - Comprehensive database health and performance metrics

2. **Node Exporter Full Dashboard**  
   - Dashboard ID: `1860`
   - Complete system resource monitoring

3. **PostgreSQL Exporter Quickstart**
   - Dashboard ID: `12485`
   - Essential PostgreSQL metrics at a glance

### Sample Prometheus Alert Rules

```yaml
groups:
- name: postgresql.rules
  rules:
  - alert: PostgreSQLDown
    expr: pg_up == 0
    for: 2m
    labels:
      severity: critical
    annotations:
      summary: "PostgreSQL instance {{ $labels.instance }} is down"
      description: "PostgreSQL database is not responding"
      
  - alert: PostgreSQLHighConnections
    expr: (pg_stat_database_numbackends / pg_settings_max_connections) * 100 > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "PostgreSQL high connection usage on {{ $labels.instance }}"
      description: "PostgreSQL connection usage is {{ $value }}%"
      
  - alert: PostgreSQLSlowQueries  
    expr: rate(pg_stat_database_tup_returned[5m]) / rate(pg_stat_database_tup_fetched[5m]) < 0.1
    for: 10m
    labels:
      severity: warning
    annotations:
      summary: "PostgreSQL slow queries detected on {{ $labels.instance }}"
      
  - alert: PostgreSQLReplicationLag
    expr: pg_stat_replication_replay_lag > 30
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "PostgreSQL replication lag on {{ $labels.instance }}"
      description: "Replication lag is {{ $value }} seconds"

- name: node.rules
  rules:
  - alert: NodeHighCPUUsage
    expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage on {{ $labels.instance }}"
      
  - alert: NodeHighMemoryUsage
    expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High memory usage on {{ $labels.instance }}"
```

## 🐛 Troubleshooting Guide

### Common Issues & Solutions

#### 1. Connection Authentication Failures

**Symptom:**
```
ERROR: pq: password authentication failed for user "postgres_exporter"
```

**Solutions:**
- Verify credentials in `DATA_SOURCE_NAME`
- Check PostgreSQL `pg_hba.conf` configuration
- Ensure user exists and has proper permissions
- Test connection manually:
  ```bash
  kubectl exec -it <pg-exporter-pod> -- psql "postgresql://user:pass@host:5432/db"
  ```

#### 2. Metrics Not Appearing in Prometheus

**Symptom:** No PostgreSQL metrics visible in Prometheus targets

**Debugging Steps:**
```bash
# Check ServiceMonitor labels match Service labels
kubectl get svc pg-exporter-service -o yaml | grep -A 10 labels
kubectl get servicemonitor pg-exporter-servicemonitor -o yaml | grep -A 10 selector

# Verify metrics endpoint is responding
kubectl port-forward svc/pg-exporter-service 9187:9187
curl http://localhost:9187/metrics

# Check Prometheus Operator logs
kubectl logs -n prometheus-system deployment/prometheus-operator
```

#### 3. High Resource Consumption

**Symptom:** Exporter pods consuming excessive CPU/memory

**Solutions:**
- Adjust scraping interval in ServiceMonitor:
  ```yaml
  spec:
    interval: 60s  # Increase from default 30s
  ```
- Optimize custom queries in `queries.yaml`
- Set resource limits:
  ```yaml
  resources:
    limits:
      cpu: 100m
      memory: 128Mi
  ```

#### 4. SSL/TLS Connection Issues

**Symptom:**
```
ERROR: pq: SSL is not enabled on the server
```

**Solutions:**
- Update connection string:
  ```
  postgresql://user:pass@host:5432/db?sslmode=disable
  ```
- Or configure PostgreSQL with SSL certificates

### Debug Commands Reference

```bash
# Pod and Service Status
kubectl get pods,svc -l app=pg-exporter
kubectl describe pod <pg-exporter-pod-name>

# Check logs with timestamps
kubectl logs <pg-exporter-pod> --timestamps --tail=50

# Test database connectivity
kubectl exec -it <pg-exporter-pod> -- nc -zv postgres-host 5432

# Inspect metrics locally
kubectl exec -it <pg-exporter-pod> -- curl -s localhost:9187/metrics | head -20

# Check environment variables
kubectl exec -it <pg-exporter-pod> -- env | grep PG_

# Validate YAML configurations
kubectl apply --dry-run=client -f exporter-db/ -f exporter-server/

# Monitor resource usage
kubectl top pods -l app=pg-exporter
```

## 📚 Advanced Configuration

### Custom Query Configuration

Create a ConfigMap for custom PostgreSQL queries:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-exporter-queries
  namespace: monitoring
data:
  queries.yaml: |
    pg_custom_table_stats:
      query: |
        SELECT
          schemaname,
          tablename,
          n_tup_ins as inserts,
          n_tup_upd as updates,
          n_tup_del as deletes
        FROM pg_stat_user_tables
      metrics:
        - schemaname:
            usage: "LABEL"
            description: "Schema name"
        - tablename:
            usage: "LABEL" 
            description: "Table name"
        - inserts:
            usage: "COUNTER"
            description: "Number of inserts"
        - updates:
            usage: "COUNTER"
            description: "Number of updates"
        - deletes:
            usage: "COUNTER"
            description: "Number of deletes"
```

### Multi-Database Monitoring

For monitoring multiple PostgreSQL instances:

```yaml
# Create separate deployments for each database
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pg-exporter-db1
spec:
  template:
    spec:
      containers:
      - name: postgres-exporter
        env:
        - name: DATA_SOURCE_NAME
          value: "postgresql://user:pass@db1-host:5432/database1"
---
apiVersion: apps/v1  
kind: Deployment
metadata:
  name: pg-exporter-db2
spec:
  template:
    spec:
      containers:
      - name: postgres-exporter
        env:
        - name: DATA_SOURCE_NAME
          value: "postgresql://user:pass@db2-host:5432/database2"
```

## 🤝 Contributing

We welcome contributions to improve this PostgreSQL monitoring setup!

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/awesome-feature`)
3. **Commit your changes** (`git commit -m 'Add awesome feature'`)
4. **Push to the branch** (`git push origin feature/awesome-feature`)
5. **Open a Pull Request**

### Contribution Guidelines

- Follow Kubernetes best practices
- Update documentation for any configuration changes
- Test deployments in a development environment
- Include relevant monitoring/alerting examples
- Write clear commit messages

### Additional Resources

- [PostgreSQL Exporter Documentation](https://github.com/prometheus-community/postgres_exporter)
- [Node Exporter Documentation](https://github.com/prometheus/node_exporter)
- [Prometheus Operator Guide](https://github.com/prometheus-operator/prometheus-operator)
- [Kubernetes Monitoring Best Practices](https://kubernetes.io/docs/concepts/cluster-administration/monitoring/)

---

**⚠️ Important Notice**: Always test configurations in a development environment before deploying to production. Ensure proper security measures and resource limits are in place.