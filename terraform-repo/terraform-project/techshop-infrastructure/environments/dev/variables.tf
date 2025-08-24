# ============================================================================
# DEV ENVIRONMENT VARIABLES
# File: environments/dev/variables.tf
# ============================================================================

# ============================================================================
# BASIC CONFIGURATION
# ============================================================================

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-southeast-2"
  
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be in format like ap-southeast-2."
  }
}


# ============================================================================
# NETWORK CONFIGURATION
# ============================================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIRD must be a valid CIDR block."
  }
}

# ============================================================================
# FEATURE FLAGS
# ============================================================================
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway for the VPC"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

# ============================================================================
# VPC ENDPOINTS CONFIGURATION
# ============================================================================

variable "enable_s3_endpoint" {
  description = "Enable S3 VPC Endpoint (Gateway - FREE)"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Enable DynamoDB VPC Endpoint (Gateway - FREE)"
  type        = bool
  default     = true
}

variable "enable_ssm_endpoint" {
  description = "Enable SSM VPC Endpoint (Interface - COSTS)"
  type        = bool
  default     = false # set to true if you use SSM to manage EC2 instances
}

# ============================================================================
# SECURITY CONFIGURATION
# ============================================================================

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to access SSH (port 22)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change this to restrict SSH access

  validation {
    condition = alltrue([
      for cidr in var.allowed_ssh_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All values must be valid CIDR blocks (e.g., 203.0.113.0/32)."
  }
}

# ============================================================================
# OPERATIONAL CONFIGURATION
# ============================================================================

variable "enable_deletion_protection" {
  description = "Enable deletion protection for critical resources"
  type        = bool
  default     = false # Set to true for production
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7 # 7 days for dev, 30+ for production

  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 35
    error_message = "Backup retention days must be between 1 and 35."
  }
}

variable "monitoring_level" {
  description = "Level of monitoring (basic, standard, detailed)"
  type        = string
  default     = "basic"

  validation {
    condition     = contains(["basic", "standard", "detailed"], var.monitoring_level)
    error_message = "Monitoring level must be one of: basic, standard, detailed."
  }
}

