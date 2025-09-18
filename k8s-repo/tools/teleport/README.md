# Teleport Kubernetes Deployment

## Overview

This repository contains Kubernetes manifests and configuration files for deploying Teleport, a modern access plane that provides secure access to infrastructure resources including Kubernetes clusters, servers, databases, and applications.

![Teleport Architecture](architecture-diagram.png)

## Architecture Components

### Core Components
- **PostgreSQL Database**: Stores Teleport cluster state and audit logs
- **Teleport Cluster**: Main cluster components including Auth and Proxy services
- **Teleport Agents**: Database and application agents for resource access
- **SSO Integration**: Single Sign-On authentication
- **Customer Resources**: Connected Kubernetes clusters, servers, databases, and applications

### Network Flow
- **Backend**: Port 5432 for database connections
- **Proxy**: Port 443 for reverse tunnel and HTTPS traffic
- **Config**: K8s API on port 6443
- **Application**: HTTP(S) traffic on port 3022
- **Database**: Ports 5432/3306 for database access

## Features

- 🔐 **Certificate-based Authentication**: No shared secrets or SSH keys required
- 🔑 **Multi-Factor Authentication (MFA)**: 2FA for all access
- 🔄 **Single Sign-On (SSO)**: Integration with GitHub Auth, OIDC, SAML
- 📊 **Audit Logging**: Comprehensive session recording and audit trails
- 🎯 **RBAC**: Fine-grained role-based access controls
- 🌐 **Web UI & CLI**: Multiple access methods
- 🔗 **Session Sharing**: Collaborative troubleshooting

## Prerequisites

- Kubernetes cluster (v1.19+)
- Helm 3.x
- Persistent storage for PostgreSQL
- Domain name with DNS management
- SSL/TLS certificates (Let's Encrypt or custom)
- Load balancer support (for cloud providers)

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/tnubeo1111/thalt.git
cd thalt/k8s-repo/tools/teleport
```

### 2. Configure Values

Copy and customize the values file:

```bash
cp values.yaml.example values.yaml
# Edit values.yaml with your specific configuration
```

### 3. Install PostgreSQL

```bash
# Install PostgreSQL using Helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgresql bitnami/postgresql \
  --set auth.postgresPassword="your-secure-password" \
  --set primary.persistence.size=20Gi
```

### 4. Deploy Teleport

```bash
# Add Teleport Helm repository
helm repo add teleport https://charts.releases.teleport.dev

# Install Teleport cluster
helm install teleport-cluster teleport/teleport-cluster \
  -f values.yaml \
  --create-namespace \
  --namespace teleport-cluster
```

### 5. Verify Installation

```bash
# Check pods status
kubectl get pods -n teleport-cluster

# Check services
kubectl get svc -n teleport-cluster

# Get Teleport admin user
kubectl logs -n teleport-cluster deployment/teleport-cluster-auth
```

## Configuration

### Core Configuration

Essential configuration parameters in `values.yaml`:

```yaml
clusterName: teleport.example.com
proxyAddr: teleport.example.com:443

# Authentication settings
auth:
  type: local  # or github, oidc, saml

# Storage configuration  
persistence:
  enabled: true
  storageClassName: "standard"
  size: 10Gi

# High Availability
highAvailability:
  replicaCount: 2
  certManager:
    enabled: true
    issuer: letsencrypt-prod
```

### Database Configuration

PostgreSQL connection settings:

```yaml
postgresql:
  host: "postgresql.default.svc.cluster.local"
  port: 5432
  database: "teleport"
  user: "postgres"
  passwordSecretName: "postgresql"
  passwordSecretKey: "postgres-password"
```

### SSO Configuration

#### GitHub SSO
```yaml
auth:
  github_auth:
    enabled: true
    client_id: "your-github-client-id"
    client_secret: "your-github-client-secret"
    teams_to_logins:
      - organization: "your-org"
        team: "admins"
        logins: ["root", "admin"]
```

#### OIDC/SAML
```yaml
auth:
  oidc_connectors:
    - id: "oidc"
      issuer_url: "https://your-oidc-provider.com"
      client_id: "teleport"
      client_secret: "your-secret"
      claims_to_roles:
        - claim: "groups"
          value: "admins"
          roles: ["admin"]
```

## Agent Deployment

### Database Agent

Deploy agents to provide access to databases:

```bash
helm install teleport-kube-agent teleport/teleport-kube-agent \
  --set roles=db \
  --set authToken="your-auth-token" \
  --set proxyAddr="teleport.example.com:443" \
  --create-namespace \
  --namespace teleport-agent
```

### Application Agent

For application access:

```bash
helm install teleport-kube-agent teleport/teleport-kube-agent \
  --set roles=app \
  --set authToken="your-auth-token" \
  --set proxyAddr="teleport.example.com:443" \
  --set apps[0].name="my-app" \
  --set apps[0].uri="http://my-app.default.svc.cluster.local:8080" \
  --namespace teleport-agent
```

## User Management

### Creating Users

```bash
# Create admin user
tctl users add admin --roles=admin --logins=root,admin

# Create developer user
tctl users add developer --roles=dev --logins=ubuntu,dev
```

### Role-Based Access Control

Example role definition:

```yaml
kind: role
version: v5
metadata:
  name: developer
spec:
  allow:
    logins: ['ubuntu', 'dev']
    kubernetes_labels:
      'env': ['dev', 'staging']
    kubernetes_groups: ['developer']
    db_labels:
      'env': ['dev']
    app_labels:
      'env': ['dev']
  deny:
    kubernetes_labels:
      'env': ['prod']
```

## Monitoring and Troubleshooting

### Health Checks

```bash
# Check cluster status
tctl status

# View connected resources
tctl get nodes
tctl get db
tctl get apps
tctl get kube_clusters
```

### Logs

```bash
# Teleport auth service logs
kubectl logs -n teleport-cluster deployment/teleport-cluster-auth

# Teleport proxy service logs  
kubectl logs -n teleport-cluster deployment/teleport-cluster-proxy

# Agent logs
kubectl logs -n teleport-agent deployment/teleport-kube-agent
```

### Common Issues

1. **Certificate Issues**
   - Check Let's Encrypt rate limits
   - Verify DNS configuration
   - Review certificate manager logs

2. **Database Connection**
   - Verify PostgreSQL credentials
   - Check network policies
   - Confirm database exists

3. **Agent Registration**
   - Validate auth tokens
   - Check proxy connectivity
   - Review firewall rules

## Security Considerations

- 🔒 Use strong passwords and rotate regularly
- 🛡️ Enable MFA for all users
- 📝 Regular audit log reviews
- 🔄 Certificate rotation and monitoring
- 🌐 Network segmentation with security groups
- 📊 Resource-based access controls
- 🚫 Principle of least privilege

## Backup and Recovery

### Database Backup

```bash
# Backup PostgreSQL
kubectl exec -n default postgresql-0 -- pg_dump -U postgres teleport > teleport_backup.sql

# Restore from backup
kubectl exec -i -n default postgresql-0 -- psql -U postgres teleport < teleport_backup.sql
```

### Configuration Backup

```bash
# Export all resources
tctl get all --format=yaml > teleport-config-backup.yaml

# Restore configuration
tctl create -f teleport-config-backup.yaml
```

## Upgrading

### Helm Upgrade

```bash
# Update Helm repository
helm repo update teleport

# Upgrade cluster
helm upgrade teleport-cluster teleport/teleport-cluster \
  -f values.yaml \
  --namespace teleport-cluster

# Upgrade agents
helm upgrade teleport-kube-agent teleport/teleport-kube-agent \
  --namespace teleport-agent
```

### Migration Notes

- Always backup before upgrading
- Review release notes for breaking changes
- Test in staging environment first
- Monitor logs during upgrade process

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

- [Teleport Documentation](https://goteleport.com/docs/)
- [Community Slack](https://goteleport.com/slack)
- [GitHub Issues](https://github.com/gravitational/teleport/issues)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

**Note**: Replace `teleport.example.com` with your actual domain name and update all placeholder values with your specific configuration.