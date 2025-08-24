
# ============================================================================
# BACKEND VARIABLES
# OWNER: ThaLT add variable for project name 
# File: global/backend/variables.tf
# ============================================================================

locals {
  aws_region = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name to be used in naming the S3 bucket"
  type        = string
  default     = "techshop"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,63}$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}