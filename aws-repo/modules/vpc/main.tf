# Create VPC resources

resource "aws_vpc" "vpc-terraform" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create Subnet resources
resource "aws_subnet" "sn-terraform" {
  vpc_id                  = aws_vpc.vpc-terraform.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.subnet_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Create route table for the VPC
resource "aws_route_table" "rtb-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id
  route {
    cidr_block = "0.0.0.0/0" # Route all traffic to the internet
    gateway_id = aws_internet_gateway.igw-terraform.id
  }
  tags = {
    Name = var.route_table_name
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "rta-terraform" {
  subnet_id      = aws_subnet.sn-terraform.id
  route_table_id = aws_route_table.rtb-terraform.id
}

# Create Internet Gateway resources
resource "aws_internet_gateway" "igw-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id
  tags = {
    Name = var.internet_gateway_name
  }
}

