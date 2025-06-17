# Create IAM role for Lambda function
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

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  count      = length(var.policy_attachments)
  role       = aws_iam_role.ec2_role_ssm.name
  policy_arn = element(var.policy_attachments, count.index)
}
