output "role_arn" {
  description = "ARN of the IAM role for Finomics access"
  value       = aws_iam_role.finomics_role.arn
}
