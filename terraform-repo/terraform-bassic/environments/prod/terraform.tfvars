# VPC Configuration for production environment
region               = "ap-southeast-2"
vpc_cidr             = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["ap-southeast-2a", "ap-southeast-2b"]

# EC2-ROLE Configuration for production environment
ec2_role_ssm_name = "ec2-role-prod-ssm"

# Key Pair Configuration for production environment
key_pair_name = "thanhtha-keypair-prod"

# EC2 Instance Configuration for production environment
ami_id           = "ami-010876b9ddd38475e"
instance_type    = "t2.micro"
key_pair         = "thanhtha-keypair-prod"
instance_name    = "thalt"
instance_profile = "ec2-instance-profile-prod"