# Create VPC resources

resource "aws_vpc" "vpc-terraform" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

# Create Subnet resources
resource "aws_subnet" "sn-terraform-public" {
  vpc_id                  = aws_vpc.vpc-terraform.id
  count                   = length(var.subnet_public_cidr_block) # Create multiple subnets if needed
  cidr_block              = element(var.subnet_public_cidr_block, count.index)
  availability_zone       = element(local.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-${var.vpc_name}-${local.availability_zone[count.index]}-public"
  }
}

resource "aws_subnet" "sn-terraform-private" {
  vpc_id            = aws_vpc.vpc-terraform.id
  count             = length(var.subnet_private_cidr_block)
  cidr_block        = element(var.subnet_private_cidr_block, count.index)
  availability_zone = element(local.availability_zone, count.index)
  tags = {
    Name = "sn-${var.vpc_name}-${local.availability_zone[count.index]}-private"
  }
}

# Create route table for the VPC
resource "aws_route_table" "rtb-terraform-public" {
  vpc_id = aws_vpc.vpc-terraform.id
  route {
    cidr_block = "0.0.0.0/0" # Route all traffic to the internet
    gateway_id = aws_internet_gateway.igw-terraform.id
  }
  tags = {
    Name = "rtb-${var.vpc_name}-public"
  }
}

resource "aws_route_table" "rtb-terraform-private" {
  vpc_id = aws_vpc.vpc-terraform.id
  tags = {
    Name = "rtb-${var.vpc_name}-private"
  }
}
# Associate the route table with the subnet
resource "aws_route_table_association" "rta-terraform-public" {
  count          = length(aws_subnet.sn-terraform-public) # Associate each public subnet with the route table
  subnet_id      = element(aws_subnet.sn-terraform-public[*].id, count.index)
  route_table_id = aws_route_table.rtb-terraform-public.id
}

resource "aws_route_table_association" "rta-terraform-private" {
  count          = length(aws_subnet.sn-terraform-private) # Associate each private subnet with the route table
  subnet_id      = element(aws_subnet.sn-terraform-private[*].id, count.index)
  route_table_id = aws_route_table.rtb-terraform-private.id
}

# Create Internet Gateway resources
resource "aws_internet_gateway" "igw-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id
  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

# Create Security Group resources
resource "aws_security_group" "sg-terraform" {
  name   = "sg.${var.vpc_name}"
  vpc_id = aws_vpc.vpc-terraform.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg.${var.vpc_name}"
  }

}