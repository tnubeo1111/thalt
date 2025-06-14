
# local variables for the VPC and Subnet configuration
locals {
  description       = "VPC and Subnet configuration for Terraform"
  availability_zone = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
}

# Variables for the VPC module

variable "aws_region" {
  description = "value of the AWS region"
  default     = "ap-southeast-2"
}


variable "vpc_cidr_block" {
  description = "value of the CIDR block for the VPC"
}

variable "vpc_name" {
  description = "value of the name for the VPC"
}

# Variables for the Subnet module
variable "subnet_public_cidr_block" {
  type        = list(any)
  description = "value of the CIDR block for the Subnet (public)"
}

variable "subnet_private_cidr_block" {
  type        = list(any)
  description = "value of the CIDR block for the Subnet (private)"
}

# variable "subnet_availability_zone" {
#   description = "value of the availability zone for the Subnet"
# }

