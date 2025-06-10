# VPC Module

module "vpc" {
  source                   = "./modules/vpc"
  vpc_cidr_block           = "10.20.0.0/16"
  vpc_name                 = "vpc-terraform"
  subnet_cidr_block        = "10.20.1.0/24"
  subnet_availability_zone = "ap-southeast-2a"
  subnet_name              = "sn-terraform"
  internet_gateway_name    = "igw-terraform"
  route_table_name         = "rtb-terraform"
}

