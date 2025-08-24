# ============================================================================
# DEV ENVIRONMENT OUTPUTS
# File: environments/dev/outputs.tf
# ============================================================================

# ============================================================================
# ENVIRONMENT INFO
# ============================================================================

output "environment_info" {
  description = "Environment configuration information"
  value = {
    environment = "dev"
    project     = "techshop"
    region      = var.aws_region
    account_id  = data.aws_caller_identity.current.account_id
    deployed_by = data.aws_caller_identity.current.user_id
    deployed_at = timestamp()
  }
}

# ============================================================================
# VPC OUTPUTS
# ============================================================================

output "vpc_info" {
  description = "VPC configuration and resource IDs"
  value = {
    vpc_id             = module.vpc.vpc_id
    vpc_arn            = module.vpc.vpc_arn
    vpc_cidr_block     = module.vpc.vpc_cidr_block
    vpc_owner_id       = module.vpc.vpc_owner_id
    availability_zones = module.vpc.availability_zones
    azs_count          = length(module.vpc.availability_zones)
  }
}

# ============================================================================
# NETWORK OUTPUTS
# ============================================================================

output "network_info" {
  description = "Network resources information"
  value = {
    # Subnets
    public_subnet_ids     = module.vpc.public_subnet_ids
    private_subnet_ids    = module.vpc.private_subnet_ids  
    database_subnet_ids   = module.vpc.database_subnet_ids
    public_subnet_cidrs   = module.vpc.public_subnet_cidrs
    private_subnet_cidrs  = module.vpc.private_subnet_cidrs
    database_subnet_cidrs = module.vpc.database_subnet_cidrs
    
    # Gateways
    internet_gateway_id = module.vpc.internet_gateway_id
    nat_gateway_ids     = module.vpc.nat_gateway_ids
    nat_public_ips      = module.vpc.nat_public_ips
    
    # Route Tables
    public_route_table_id    = module.vpc.public_route_table_id
    private_route_table_ids  = module.vpc.private_route_table_ids
    database_route_table_id  = module.vpc.database_route_table_id
  }
}

# ============================================================================
# SECURITY OUTPUTS
# ============================================================================

output "security_groups" {
  description = "Security group IDs for different tiers"
  value = {
    bastion_sg_id  = module.vpc.bastion_security_group_id
    alb_sg_id      = module.vpc.alb_security_group_id
    web_sg_id      = module.vpc.web_security_group_id
    app_sg_id      = module.vpc.app_security_group_id
    database_sg_id = module.vpc.database_security_group_id
  }
}

# ============================================================================
# VPC ENDPOINTS OUTPUTS
# ============================================================================

output "vpc_endpoints" {
  description = "VPC endpoints information"
  value = {
    s3_endpoint_id       = module.vpc.s3_endpoint_id
    dynamodb_endpoint_id = module.vpc.dynamodb_endpoint_id
    ssm_endpoint_ids     = module.vpc.ssm_endpoint_ids
  }
}

# ============================================================================
# DATABASE RESOURCES
# ============================================================================

output "database_resources" {
  description = "Database-related resource identifiers"
  value = {
    db_subnet_group_name    = module.vpc.db_subnet_group_name
    db_subnet_group_arn     = module.vpc.db_subnet_group_arn
    cache_subnet_group_name = module.vpc.cache_subnet_group_name
  }
}

# ============================================================================
# MONITORING RESOURCES
# ============================================================================

output "monitoring_resources" {
  description = "Monitoring and logging resources"
  value = {
    flow_logs_log_group_name = module.vpc.flow_logs_log_group_name
    flow_logs_log_group_arn  = module.vpc.flow_logs_log_group_arn
    flow_logs_id             = module.vpc.flow_logs_id
  }
}

# ============================================================================
# COST INFORMATION
# ============================================================================

output "cost_estimate" {
  description = "Estimated monthly costs for dev environment"
  value = {
    vpc_related = "~$0 (VPC, IGW, Subnets are free)"
    nat_gateway = var.enable_nat_gateway ? (var.single_nat_gateway ? "~$32.40/month (1 NAT GW)" : "~$97.20/month (3 NAT GWs)") : "$0"
    vpc_endpoints = var.enable_ssm_endpoint ? "~$21.60/month (SSM endpoints)" : "$0 (only free Gateway endpoints)"
    flow_logs = var.enable_flow_logs ? "~$3-5/month (CloudWatch logs)" : "$0"
    total_estimate = var.enable_nat_gateway && var.enable_ssm_endpoint ? "~$57-62/month" : (var.enable_nat_gateway ? "~$35-40/month" : "~$3-5/month")
  }
}

# ============================================================================
# NEXT STEPS
# ============================================================================

output "next_steps" {
  description = "Information for next deployment phases"
  value = {
    phase_1_complete = "✅ Foundation infrastructure deployed"
    phase_2_ready = {
      compute_module = "Ready to deploy EC2, ALB, Auto Scaling"
      required_inputs = {
        vpc_id = module.vpc.vpc_id
        public_subnet_ids = module.vpc.public_subnet_ids
        private_subnet_ids = module.vpc.private_subnet_ids
        security_group_ids = {
          alb = module.vpc.alb_security_group_id
          web = module.vpc.web_security_group_id
          app = module.vpc.app_security_group_id
        }
      }
    }
    database_module = "Ready to deploy RDS, ElastiCache"
    required_security_groups = module.vpc.database_security_group_id
  }
}