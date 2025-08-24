# This file is part of the Terraform configuration for managing AWS EC2 instances.
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.instance_profile
  role = var.instance_role
}

# Terraform configuration for EC2 instances
resource "aws_instance" "ec2_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id[0] # Use the first subnet ID from the list
  key_name             = var.key_pair
  security_groups      = var.security_group_ids
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "ec2-${var.environment}-${var.instance_name}"
  }
}

