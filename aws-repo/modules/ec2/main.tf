# Create module for EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.instance_profile
  role = var.instance_role
}

resource "aws_instance" "ec2_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    count = length(var.subnet_id)
    subnet_id = element(var.subnet_id, count.index)
    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_ids
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
    tags = {
        Name = var.instance_name
    }
}