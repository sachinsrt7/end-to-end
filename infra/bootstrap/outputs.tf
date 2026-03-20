output "s3_bucket_name" {
  description = "S3 bucket for Terraform remote state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB table for state locking"
  value       = aws_dynamodb_table.tf_lock.name
}

output "payment_service_ecr_url" {
  description = "ECR URL for payment-service"
  value       = aws_ecr_repository.payment_service.repository_url
}

output "auth_service_ecr_url" {
  description = "ECR URL for auth-service"
  value       = aws_ecr_repository.auth_service.repository_url
}
