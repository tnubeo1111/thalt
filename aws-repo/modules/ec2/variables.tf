# Variavbles for the EC2 module
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = list(any)
}
variable "key_pair" {
  description = "Name of the key pair to use for the EC2 instance"
  type        = string
}
variable "security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_profile" {
  description = "IAM instance profile name for the EC2 instance"
  type        = string
}
variable "instance_role" {
  description = "IAM role name for the EC2 instance"
  type        = string
}