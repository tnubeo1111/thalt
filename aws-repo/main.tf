# VPC Module

module "vpc" {
  source                    = "./modules/vpc"
  vpc_cidr_block            = "10.20.0.0/16"
  vpc_name                  = "terraform"
  subnet_public_cidr_block  = ["10.20.1.0/24", "10.20.2.0/24"]
  subnet_private_cidr_block = ["10.20.3.0/24"]
}

# IAM Role Module for Lambda
module "lambda_role" {
  source           = "./modules/iam/role/lambda"
  lambda_role_name = "lambda-ec2-role"
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