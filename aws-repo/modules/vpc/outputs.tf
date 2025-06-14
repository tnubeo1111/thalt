# Outputs for the VPC module

output "vpc_id" {
  description = "value of the ID of the VPC"
  value       = aws_vpc.vpc-terraform.id
}

output "vpc_cidr_block" {
  description = "value of the CIDR block for the VPC"
  value       = aws_vpc.vpc-terraform.cidr_block
}

output "subnet_public_ids" {
  description = "value of the IDs of the public subnets"
  value       = aws_subnet.sn-terraform-public[*].id
}

output "subnet_private_ids" {
  description = "value of the IDs of the private subnets"
  value       = aws_subnet.sn-terraform-private[*].id
}

output "internet_gateway_id" {
  description = "value of the ID of the Internet Gateway"
  value = aws_internet_gateway.igw-terraform.id
}

output "aws_security_group_id" {
  description = "value of the ID of the Security Group"
  value = aws_security_group.sg-terraform.id
}