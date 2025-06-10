# Outputs for the VPC module

output "vpc_id" {
  description = "value of the ID of the VPC"
  value       = aws_vpc.vpc-terraform.id
}

output "vpc_cidr_block" {
  description = "value of the CIDR block for the VPC"
  value       = aws_vpc.vpc-terraform.cidr_block
}

# Outputs for the Subnet module
output "subnet_id" {
  description = "value of the ID of the Subnet"
  value       = aws_subnet.sn-terraform.id
}

output "internet_gateway_id" {
  description = "value of the ID of the Internet Gateway"
  value       = aws_internet_gateway.igw-terraform.id
}