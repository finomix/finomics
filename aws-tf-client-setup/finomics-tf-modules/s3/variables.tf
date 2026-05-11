variable "bucket_name" {
  description = "S3 bucket name for FOCUS exports"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "pipeline_role_arn" {
  description = "Pipeline role ARN for S3 cross-account access"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID of the management account"
  type        = string
}

variable "org_id" {
  description = "AWS Organizations ID (e.g. o-xxxxxxxxxx) — used to scope bucket policy to all org accounts"
  type        = string
}
