output "bucket_name" {
  description = "Name of the S3 bucket for Finomics"
  value       = aws_s3_bucket.finomics_bucket.id
}
