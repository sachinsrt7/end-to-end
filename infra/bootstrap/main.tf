terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2" #hyderabad
}

# S3 bucket for Terraform remote state
resource "aws_s3_bucket" "tf_state" {
  bucket        = "modak-tf-state-625693792644"
  force_destroy = true

  tags = {
    Name    = "modak-tf-state"
    Project = "modak-platform"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = "modak-tf-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "modak-tf-lock"
    Project = "modak-platform"
  }
}

# ECR repo for payment-service
resource "aws_ecr_repository" "payment_service" {
  name                 = "payment-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = "payment-service"
    Project = "modak-platform"
  }
}

# ECR repo for auth-service
resource "aws_ecr_repository" "auth_service" {
  name                 = "auth-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = "auth-service"
    Project = "modak-platform"
  }
}
