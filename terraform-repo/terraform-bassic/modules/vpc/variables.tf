variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., prod, sandbox)"
  type        = string
}

variable "ssh_ingress_cidr" {
  description = "CIDR block for SSH ingress"
  type        = list(string)
}