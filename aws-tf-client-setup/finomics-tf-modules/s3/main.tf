# S3 Bucket for FOCUS Data Exports (central bucket in management account)
resource "aws_s3_bucket" "finomics_bucket" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "finomics_bucket_pab" {
  bucket = aws_s3_bucket.finomics_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.finomics_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy:
#  - FOCUS Data Exports service (bcm-data-exports.amazonaws.com) can write from any account in the org
#  - All IAM principals in the org can write to the entire bucket (child accounts)
#  - Finomics pipeline role can read
resource "aws_s3_bucket_policy" "finomics_bucket_policy" {
  bucket = aws_s3_bucket.finomics_bucket.id

  # Public-access block must exist before the policy is applied
  depends_on = [aws_s3_bucket_public_access_block.finomics_bucket_pab]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Allow the AWS Data Exports (FOCUS) service to write export files
      # from any account belonging to the organization
      {
        Sid    = "AllowFocusDataExportWrite"
        Effect = "Allow"
        Principal = {
          Service = "bcm-data-exports.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.finomics_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceOrgID" = var.org_id
          }
        }
      },

      # Allow the service to read the bucket policy (required during export setup)
      {
        Sid    = "AllowFocusDataExportGetPolicy"
        Effect = "Allow"
        Principal = {
          Service = "bcm-data-exports.amazonaws.com"
        }
        Action   = "s3:GetBucketPolicy"
        Resource = aws_s3_bucket.finomics_bucket.arn
        Condition = {
          StringEquals = {
            "aws:SourceOrgID" = var.org_id
          }
        }
      },

      # Allow any IAM principal from any account in the org to write objects
      # This covers child accounts exporting FOCUS data manually or via automation
      {
        Sid    = "AllowOrgAccountsWrite"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload"
        ]
        Resource = "${aws_s3_bucket.finomics_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = var.org_id
          }
        }
      },

      # Allow org principals to list and locate the bucket
      {
        Sid    = "AllowOrgAccountsList"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = aws_s3_bucket.finomics_bucket.arn
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = var.org_id
          }
        }
      },

      # Finomics pipeline role: read access to consume exported data
      {
        Sid    = "AllowPipelineRoleAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.pipeline_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketVersioning",
          "s3:GetBucketPolicyStatus",
          "s3:GetEncryptionConfiguration"
        ]
        Resource = [
          aws_s3_bucket.finomics_bucket.arn,
          "${aws_s3_bucket.finomics_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Folder prefixes for FOCUS export data
resource "aws_s3_object" "focus_daily_folder" {
  bucket       = aws_s3_bucket.finomics_bucket.id
  key          = "focus-exports/focus-daily/"
  content      = ""
  content_type = "application/x-directory"
}

resource "aws_s3_object" "focus_monthly_folder" {
  bucket       = aws_s3_bucket.finomics_bucket.id
  key          = "focus-exports/focus-monthly/"
  content      = ""
  content_type = "application/x-directory"
}
