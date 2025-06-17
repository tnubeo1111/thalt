# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  count      = length(var.policy_attachments)
  role       = aws_iam_role.lambda_role.name
  policy_arn = element(var.policy_attachments, count.index)
}
