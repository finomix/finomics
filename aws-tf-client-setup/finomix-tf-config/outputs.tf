# --------------------
# S3 Outputs
# --------------------
output "bucket_name" {
  description = "Name of the S3 bucket for Finomics"
  value       = module.s3.bucket_name
}

# --------------------
# IAM Outputs
# --------------------
output "role_arn" {
  description = "ARN of the IAM Role used for Finomics access"
  value       = module.iam.role_arn
}
