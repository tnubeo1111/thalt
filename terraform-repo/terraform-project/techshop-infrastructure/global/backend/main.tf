# Data source to fetch the current AWS caller identity
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Local variables for resource naming and configuration
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

# ============================================================================
# S3 BUCKET FOR TERRAFORM STATE
# OWNER: ThaLT add state bucket for remote state storage
# PURPOSE: Create an S3 bucket to store Terraform state files with versioning, encryption,
#          and lifecycle policies to ensure data integrity and security.
# DATE: 2024-08-2025
# ============================================================================

# S3 bucket for Terraform state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-terraform-state-${local.account_id}"

  # Prevent accidental deletion of the bucket
  lifecycle {
    prevent_destroy = false # Set to true to prevent deletion
  }

  tags = {
    Name        = "${var.project_name}-terraform-state"
    Description = "Terraform remote state storage"
  }
}
# Enable versioning on the S3 bucket to keep track of state file changes
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption on the S3 bucket using AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access settings to restrict public access to the bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle policy to automatically delete objects after 90 days
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  depends_on = [aws_s3_bucket_versioning.terraform_state]
  bucket     = aws_s3_bucket.terraform_state.id

  rule {
    id     = "terraform-state-lifecycle"
    status = "Enabled"

    # Delete versioned old objects after 90 days
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    # Delete multipart uploads after 7 days
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# ============================================================================
# DYNAMODB TABLE FOR STATE LOCKING
# OWNER: ThaLT add state locking table for remote state storage
# PURPOSE: Create a DynamoDB table to manage state locking and consistency for Terraform operations.
# DATE: 2024-08-2025
# ============================================================================
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.project_name}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  # Enable point-in-time recovery for the table
  point_in_time_recovery {
    enabled = true
  }

  # Sever-side encryption
  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = false # Set to true to prevent deletion
  }

  tags = {
    Name        = "${var.project_name}-terraform-locks"
    Description = "DynamoDB table for Terraform state locking"
  }
}