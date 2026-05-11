# Main Configuration Variables
# Update these values according to your AWS environment

# AWS Configuration
aws_region = "us-east-1"
account_id = "165446266030"

# AWS Organizations ID — find it in AWS Organizations console or via:
# aws organizations describe-organization --query 'Organization.Id' --output text
org_id = "o-ri54766xyn"

# S3 Bucket for FOCUS exports (central bucket in management account)
bucket_name = "finomics-s3-bucket-new1"

# Environment
environment = "dev"

# IAM Role Configuration
role_name = "finomics-access-role-new1"

# Trusted Accounts and Roles
trusted_account_arn = [
  "arn:aws:iam::364582896484:role/finomics_data_pipeline_role"
]

# Pipeline Role ARN for S3 Cross-Account Access
pipeline_role_arn = "arn:aws:iam::364582896484:role/finomics_data_pipeline_role"

# IAM Policy Names
policy_name       = "finomics-access-policy-new1"
extra_policy_name = "iam-terraform-onboarding-policies-new1"
