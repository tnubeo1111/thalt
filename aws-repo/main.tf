# VPC Module

module "vpc" {
  source                    = "./modules/vpc"
  vpc_cidr_block            = "10.20.0.0/16"
  vpc_name                  = "terraform"
  subnet_public_cidr_block  = ["10.20.1.0/24", "10.20.2.0/24"]
  subnet_private_cidr_block = ["10.20.3.0/24"]
}

