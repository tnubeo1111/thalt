# Terraform configuration for VPC
module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
  environment          = "prod"
}

# Terraform configuration for IAM role for EC2 instances
# This module creates an IAM role that allows EC2 instances to use SSM
module "ec2_role_ssm" {
  source                = "../../modules/iam-role/ec2"
  ec2_role_ssm_name     = var.ec2_role_ssm_name
}

module "key_pair" {
  source = "../../modules/key-pair"
  key_pair_name = var.key_pair_name
  public_key = file("/home/thanhtha/.ssh/ssh.pub")
}

# Terraform configuration for EC2 instances
module "ec2" {
  source               = "../../modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_ids
  key_pair = module.key_pair.key_pair_id
  security_group_ids = [module.vpc.security_group_ids]
  instance_profile = var.instance_profile
  instance_role = module.ec2_role_ssm.ec2_role_ssm_name
  instance_name = var.instance_name
  environment = "prod"
}