# ============================================================================
# VPC MODULE - MAIN RESOURCES
# File: modules/vpc/main.tf
# ============================================================================

# Get current region data
data "aws_region" "current" {}

# ============================================================================
# VPC RESOURCE
# ============================================================================

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-vpc"
    Description = "Main VPC for ${var.project} ${var.environment} environment"
    CidrBlock = var.vpc_cidr
  })
}

# ============================================================================
# INTERNET GATEWAY
# ============================================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-igw"
  })
}

# ============================================================================
# SUBNETS - PUBLIC TIER
# ============================================================================

resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_customer_owned_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-public-${substr(var.availability_zones[count.index], -1, 1)}"
    Type = "Public"
    Tier = "Web/LoadBalancer"
    AZ   = var.availability_zones[count.index]
    # Kubernetes cluster tags if needed later
    "kubernetes.io/role/elb" = "1"
  })
}

# ============================================================================
# SUBNETS - PRIVATE TIER
# ============================================================================

resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnets_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-private-${substr(var.availability_zones[count.index], -1, 1)}"
    Type = "Private"
    Tier = "Application"
    AZ   = var.availability_zones[count.index]
    # Kubernetes cluster tags if needed later
    "kubernetes.io/role/internal-elb" = "1"
  })
}

# ============================================================================
# SUBNETS - DATABASE TIER
# ============================================================================

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-db-${substr(var.availability_zones[count.index], -1, 1)}"
    Type = "Private"
    Tier = "Database"
    AZ   = var.availability_zones[count.index]
  })
}