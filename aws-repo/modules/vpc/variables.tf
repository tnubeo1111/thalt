# Variables for the VPC module

variable "vpc_cidr_block" {
  description = "value of the CIDR block for the VPC"
}

variable "vpc_name" {
  description = "value of the name for the VPC"
}

# Variables for the Subnet module
variable "subnet_cidr_block" {
  description = "value of the CIDR block for the Subnet"
}

variable "subnet_availability_zone" {
  description = "value of the availability zone for the Subnet"
}

variable "subnet_name" {
  description = "value of the name for the Subnet"
}

# Variables for the Route Table module
variable "route_table_name" {
  description = "value of the name for the Route Table"
}

# Variables for the Internet Gateway module
variable "internet_gateway_name" {
  description = "value of the name for the Internet Gateway"
}
