# VPC Module

module "vpc" {
  source                    = "./modules/vpc"
  vpc_cidr_block            = "10.20.0.0/16"
  vpc_name                  = "terraform"
  subnet_public_cidr_block  = ["10.20.1.0/24"]
  subnet_private_cidr_block = ["10.20.3.0/24"]
}

# IAM Role Module for Lambda
module "lambda_role" {
  source           = "./modules/iam/role/lambda"
  lambda_role_name = "lambda-ec2-role"
}

# IAM Role Module for EC2
module "ec2_role" {
  source = "./modules/iam/role/ec2" 
  ec2_role_ssm_name = "EC2-SSM-Role"
}

# Key Pair Module
module "key_pair" {
  source        = "./modules/key-pair"
  key_pair_name = "local"
  public_key    = file("/home/thanhtha/.ssh/ssh.pub")
}

# Lambda Function Module
module "lambda_function" {
  source          = "./modules/lambda"
  lambda_role_name = module.lambda_role.lambda_role_arn
  lambda_function_name = "aws_config_lambda_function"
  lambda_runtime = "python3.12"
  lambda_function_filename = "/home/thanhtha/github/thalt/aws-repo/modules/lambda/code/lambda_function_awsconfig.zip"
  lambda_function_source_code_hash = filebase64sha256("/home/thanhtha/github/thalt/aws-repo/modules/lambda/code/lambda_function_awsconfig.zip")
  lambda_function_timeout = 10
}

# EC2 Instance Module
module "ec2_instance" {
  source              = "./modules/ec2"
  ami_id              = "ami-034488765f896f58f" # Replace with your AMI ID
  instance_type       = "t2.micro" # Replace with your desired instance type
  subnet_id           = module.vpc.subnet_public_ids
  key_pair            = module.key_pair.key_pair_id
  security_group_ids  = [module.vpc.aws_security_group_id]
  instance_name       = "terraform-ec2-instance"
  instance_profile    = "terraform-ec2-instance-profile"
  instance_role       = module.ec2_role.ec2_role_ssm_name
}