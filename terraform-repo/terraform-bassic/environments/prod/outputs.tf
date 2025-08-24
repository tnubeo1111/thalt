#Terraform configuration for VPC 
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# Output for IAM role for EC2 instances
output "ec2_role_ssm_name" {
  description = "Name of the IAM role for EC2 instances"
  value       = module.ec2_role_ssm.ec2_role_ssm_name
}

# Output for Key Pair
output "key_pair_name" {
  description = "Name of the EC2 key pair"
  value       = module.key_pair.key_pair_id
}

# Output for EC2 instance
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.ec2_instance_id
}
output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.ec2_instance_public_ip
}

output "ec2_instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.ec2.ec2_instance_private_ip
}