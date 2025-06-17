variable "ec2_role_ssm_name" {
  description = "value for the name of the Lambda IAM role"
  type        = string
}

variable "policy_attachments" {
  description = "List of policy ARNs to attach to the Lambda role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchActionsEC2Access",
    "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
  ]
}