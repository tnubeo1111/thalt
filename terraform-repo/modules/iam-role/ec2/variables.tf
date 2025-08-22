variable "ec2_role_ssm_name" {
  description = "value for the name of the IAM role for EC2 instances"
    type        = string
}

variable "ec2_ssm_policy_attachment" {
  description = "List of IAM policy ARNs to attach to the EC2 role"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchActionsEC2Access",
    "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
    ]
  
}