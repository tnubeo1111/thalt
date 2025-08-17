# Create VPC and related resources
resource "aws_vpc" "vpc-thalt" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "${var.environment}-vpc"
    }
}

# Create subnets for the VPC
resource "aws_subnet" "subnet-public-thalt" {
    vpc_id = aws_vpc.vpc-thalt.id
    count = length(var.public_subnets_cidr)
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
      Name = "sn-${var.environment}-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "subnet-private-thalt" {
    vpc_id = aws_vpc.vpc-thalt.id
    count = length(var.private_subnets_cidr)
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    tags = {
      Name = "sn-${var.environment}-private-subnet-${count.index + 1}"
    }
}

# Create Internet Gateway for the VPC
resource "aws_internet_gateway" "igw-thalt" {
    vpc_id = aws_vpc.vpc-thalt.id
    tags = {
        Name = "igw-${var.environment}-internet-gateway"
    }
}

# Create Route Table for public subnets
resource "aws_route_table" "public-route-table-thalt" {
    vpc_id = aws_vpc.vpc-thalt.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-thalt.id
    }
    tags = {
        Name = "rtb-${var.environment}-public-route-table"
    }
}

# Create Route Table for private subnets
resource "aws_route_table" "private-route-table-thalt" {
    vpc_id = aws_vpc.vpc-thalt.id
    tags = {
        Name = "rtb-${var.environment}-private-route-table"
    }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "rtb-association-public-thalt" {
    count = length(aws_subnet.subnet-public-thalt)
    subnet_id = aws_subnet.subnet-public-thalt[count.index].id
    route_table_id = aws_route_table.public-route-table-thalt.id
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "rtb-association-private-thalt" {
    count = length(aws_subnet.subnet-private-thalt)
    subnet_id = aws_subnet.subnet-private-thalt[count.index].id
    route_table_id = aws_route_table.private-route-table-thalt.id
}

# Create Security Group resources
resource "aws_security_group" "sg-thalt" {
    vpc_id = aws_vpc.vpc-thalt.id
    name = "${var.environment}-sg"
    description = "Security group for ${var.environment} environment"

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
    # Add tags to the security group
    tags = {
        Name = "sg.${var.environment}-security-group"
    }
}

