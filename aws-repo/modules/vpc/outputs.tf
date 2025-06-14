# Outputs for the VPC module

output "vpc_id" {
  description = "value of the ID of the VPC"
  value       = aws_vpc.vpc-terraform.id
}

output "vpc_cidr_block" {
  description = "value of the CIDR block for the VPC"
  value       = aws_vpc.vpc-terraform.cidr_block
}