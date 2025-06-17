variable "lambda_role_name" {
    description = "The name of the Lambda role"
    type        = string
}

variable "lambda_function_name" {
    description = "The name of the Lambda function"
    type        = string
}

variable "lambda_runtime" {
    description = "The runtime environment for the Lambda function"
    type        = string
}
variable "lambda_function_filename" {
    description = "The filename of the Lambda function deployment package"
    type        = string
}
variable "lambda_function_source_code_hash" {
    description = "The base64-encoded SHA256 hash of the deployment package"
    type        = string
}

variable "lambda_function_timeout" {
    description = "The timeout in seconds for the Lambda function"
    type        = number
}