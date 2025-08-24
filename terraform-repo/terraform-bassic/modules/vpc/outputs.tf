output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc-thalt.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.subnet-public-thalt[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.subnet-private-thalt[*].id
}

output "security_group_ids" {
  description = "IDs of security groups"
  value       = aws_security_group.sg-thalt.id

}