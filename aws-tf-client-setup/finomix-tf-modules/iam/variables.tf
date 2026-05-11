variable "role_name" {
  description = "Name of the IAM role for Finomics"
  type        = string
  default     = "Finomics-Access-Role"
}

variable "extra_policy_name" {
  description = "Name of the inline policy for Finomics role"
  type        = string
  default     = "Finomics-ReadOnly-Policy"
}

variable "trusted_account_arn" {
  description = "List of trusted AWS account and role ARNs"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "central_role_name" {
  description = "Role name in the central accounts that will assume this role"
  type        = string
  default     = "OrganizationRole"
}
