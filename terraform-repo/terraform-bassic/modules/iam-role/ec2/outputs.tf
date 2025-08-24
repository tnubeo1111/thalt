output "ec2_role_ssm_arn" {
  description = "value for the ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role_ssm.arn
}

output "ec2_role_ssm_name" {
  description = "value for the name of the EC2 IAM role"
  value       = aws_iam_role.ec2_role_ssm.name

}