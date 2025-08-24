# Create IAM role for EC2 instances
resource "aws_iam_role" "ec2_role_ssm" {
  name = var.ec2_role_ssm_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  count      = length(var.ec2_ssm_policy_attachment)
  role       = aws_iam_role.ec2_role_ssm.name
  policy_arn = element(var.ec2_ssm_policy_attachment, count.index)

}