# This file is part of a Terraform module for managing AWS Lambda functions.
resource "aws_lambda_function" "aws_config" {
    function_name = var.lambda_function_name
    role = var.lambda_role_name
    runtime = var.lambda_runtime
    handler = "lambda_function.lambda_handler"

    filename = var.lambda_function_filename
    source_code_hash = var.lambda_function_source_code_hash
    timeout = var.lambda_function_timeout
}