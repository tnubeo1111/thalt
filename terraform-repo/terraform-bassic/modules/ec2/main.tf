# Terraform configuration for EC2 instances
resource "aws_instance" "ec2_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  key_name             = var.key_pair
  security_groups      = var.security_group_ids
  iam_instance_profile = var.instance_profile
  tags = {
    Name = "ec2-${var.environment}-${var.instance_name}"
  }
}