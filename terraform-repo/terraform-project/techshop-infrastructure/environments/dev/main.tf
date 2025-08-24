# Provider configuration với dev-specific settings
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = local.common_tags
  }
}

# ============================================================================
# DATA SOURCES
# ============================================================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get availability zones in the current region
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# ============================================================================
# LOCAL VALUES
# ============================================================================

locals {
  environment = "dev"
  project     = "techshop"

  # Common tags for all resources
  common_tags = {
    Environment  = local.environment
    project      = local.project
    ManagedBy    = "Terraform"
    Onwer        = "Cloud Team - ThaLT"
    CostCenter   = "engineering"
    Application  = "e-commerce-platform"
    BackupPolicy = "dev"
    DataClass    = "Internal"
    CreatedBy    = data.aws_caller_identity.current.user_id
  }

  # Network configuration
  vpc_cidr = var.vpc_cidr

  # Calculate AZs - use first 2 available zones
  azs_count = min(2, length(data.aws_availability_zones.available.names))
  azs       = slice(data.aws_availability_zones.available.names, 0, local.azs_count)

  # CIDR calculations using cidrsubnet function
  # Public subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
  public_subnets = [
    for i in range(local.azs_count) : cidrsubnet(local.vpc_cidr, 8, i + 1)
  ]

  # Private subnets: 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24
  private_subnets = [
    for i in range(local.azs_count) : cidrsubnet(local.vpc_cidr, 8, i + 11)
  ]

  # Database subnets: 10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24
  database_subnets = [
    for i in range(local.azs_count) : cidrsubnet(local.vpc_cidr, 8, i + 21)
  ]
}

# ============================================================================
# VPC MODULE
# ============================================================================

module "vpc" {
  source = "../../modules/vpc"

  # Basic configuration
  environment = local.environment
  project     = local.project

  # Network configuration
  vpc_cidr               = local.vpc_cidr
  availability_zones     = local.azs
  public_subnets_cidrs   = local.public_subnets
  private_subnets_cidrs  = local.private_subnets
  database_subnets_cidrs = local.database_subnets

  # Features toggles
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  enable_flow_logs     = var.enable_flow_logs

  # Security groups configuration
  allowed_ssh_cidrs = var.allowed_ssh_cidrs

  # VPC Endpoints configuration
  enable_s3_endpoint       = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint
  enable_ssm_endpoint      = var.enable_ssm_endpoint

  # Tags
  tags = local.common_tags
}
