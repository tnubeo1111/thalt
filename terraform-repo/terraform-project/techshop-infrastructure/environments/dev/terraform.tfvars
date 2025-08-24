# ============================================================================
# DEV ENVIRONMENT CONFIGURATION
# File: environments/dev/terraform.tfvars
# ============================================================================

# ============================================================================
# NETWORK CONFIGURATION
# ============================================================================

vpc_cidr = "10.0.0.0/16"  # 65,536 IP addresses

# ============================================================================
# FEATURE FLAGS - DEV ENVIRONMENT
# ============================================================================

# DNS configuration
enable_dns_hostnames = true
enable_dns_support   = true

# NAT Gateway configuration (cost optimization for dev)
enable_nat_gateway  = true
single_nat_gateway  = true  # Use single NAT GW to save cost (~$32/month vs $97/month)

# VPN Gateway (usually not needed for dev)
enable_vpn_gateway = false

# VPC Flow Logs (recommended for security)
enable_flow_logs = true

# ============================================================================
# VPC ENDPOINTS CONFIGURATION
# ============================================================================

# Free Gateway endpoints (recommended)
enable_s3_endpoint       = true   # No cost
enable_dynamodb_endpoint = true   # No cost

# Interface endpoints (paid - ~$7.20/month each)
enable_ssm_endpoint = false  # Set to true if you need SSM Session Manager

# ============================================================================
# SECURITY CONFIGURATION
# ============================================================================

# ⚠️ IMPORTANT: Replace with your actual IP address
# Use: curl ifconfig.me to get your IP
allowed_ssh_cidrs = [
  "0.0.0.0/0"  # 🚨 CHANGE THIS! Example: ["203.0.113.100/32"]
]
# Example secure configurations:
# allowed_ssh_cidrs = ["203.0.113.100/32"]  # Your home IP
# allowed_ssh_cidrs = ["10.1.0.0/16"]       # Your office network
# allowed_ssh_cidrs = [
#   "203.0.113.100/32",  # Your home
#   "198.51.100.0/24"    # Your office
# ]

# ============================================================================
# OPERATIONAL CONFIGURATION
# ============================================================================

# Deletion protection (false for dev, true for prod)
enable_deletion_protection = false

# Backup retention (shorter for dev)
backup_retention_days = 7

# Monitoring level (basic for dev)
monitoring_level = "basic"

# ============================================================================
# COST OPTIMIZATION NOTES
# ============================================================================

# Current configuration cost estimate:
# - VPC, IGW, Subnets: FREE
# - Single NAT Gateway: ~$32.40/month
# - VPC Flow Logs: ~$3-5/month  
# - Total: ~$35-40/month for dev environment
#
# To reduce costs further:
# - Set enable_nat_gateway = false (but private instances can't reach internet)
# - Set enable_flow_logs = false (reduces security monitoring)