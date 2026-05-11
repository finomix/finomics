variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for FOCUS exports"
  type        = string
  default     = "finomics-s3-bucket"
}

variable "org_id" {
  description = "AWS Organizations ID (e.g. o-xxxxxxxxxx)"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "role_name" {
  description = "IAM role name for Finomics access"
  type        = string
  default     = "finomics-access-role"
}

variable "trusted_account_arn" {
  description = "List of trusted AWS account and role ARNs"
  type        = list(string)
}

variable "pipeline_role_arn" {
  description = "Pipeline role ARN for S3 cross-account access"
  type        = string
}

variable "policy_name" {
  description = "Name for the IAM policy"
  type        = string
  default     = "finomics-access-policy"
}

variable "extra_policy_name" {
  description = "Name for the extended IAM policy"
  type        = string
  default     = "iam-terraform-onboarding-policies"
}
