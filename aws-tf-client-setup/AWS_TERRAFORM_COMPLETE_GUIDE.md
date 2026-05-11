# Terraform AWS Finomics - Complete Guide (S3, IAM)

## Table of Contents

1. Overview
2. Project Structure
3. Terraform Files
4. Modules Breakdown
5. How to Run
6. What Happens on Apply
7. Outputs
8. Troubleshooting
9. Security Best Practices
10. Next Steps

---

## Overview

This Terraform configuration provisions AWS resources for Finomics reporting and access:

- S3 bucket for data delivery (versioning enabled, cross-account access for pipeline role)
- IAM role and inline policy for cross-account access and analytics
- Helper local-exec to enroll Compute Optimizer (optional)

**Primary Region:** `us-east-1`
**Backend:** Amazon S3 for state management

---

## Project Structure

```
finomics-infra-tf-code/
├── finomics-tf-config/              # Root configuration (entry point)
│   ├── backend.tf                  # Remote state backend (S3)
│   ├── main.tf                     # Root module orchestration
│   ├── outputs.tf                  # Root outputs
│   ├── provider.tf                 # AWS provider config
│   ├── terraform.tfvars            # Variable values
│   └── variables.tf                # Top-level variables
└── finomics-tf-modules/             # Reusable modules
    ├── iam/                        # IAM role + inline policy
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── s3/                         # S3 bucket + policies
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

---

## Terraform Files

### 1. `finomics-tf-config/backend.tf` – State Management

```hcl
terraform {
  backend "s3" {
    bucket  = "aws-terraform-herbalife-statefile"
    key     = "terraform-2/state/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

Purpose:

- Stores Terraform state in S3 to enable collaboration.
- Uses server-side encryption and a deterministic state key.

### 2. `finomics-tf-config/provider.tf` – AWS Provider

```hcl
provider "aws" {
  region = var.aws_region
}
```

### 3. `finomics-tf-config/main.tf` – Root Orchestration

- Calls modules: `s3`, `iam`.
- Includes a `null_resource` with `local-exec` to enroll Compute Optimizer:
  ```hcl
  resource "null_resource" "enable_compute_optimizer" {
    provisioner "local-exec" {
      command = "aws compute-optimizer update-enrollment-status --status Active"
    }
  }
  ```

  Requires AWS CLI with permissions to call `compute-optimizer:UpdateEnrollmentStatus`.

### 4. `finomics-tf-config/variables.tf` – Input Variables

Key variables:

- `aws_region`, `account_id` – deployment coordinates
- `bucket_name` – S3 bucket name
- `environment` – environment tag
- `role_name`, `trusted_account_arn`, `extra_policy_name` – IAM settings
- `pipeline_role_arn` – cross-account principal used in S3 policy

### 5. `finomics-tf-config/terraform.tfvars` – Variable Values

Update the variables in [terraform.tfvars](finomics-infra-tf-code/finomics-tf-config/terraform.tfvars) with values for your AWS environment. This file supplies concrete values for the variables declared in `variables.tf` and is loaded automatically by Terraform.

Values to update:

- `aws_region`, `account_id` – your AWS region and child account ID
- `org_id` – your AWS Organizations ID
- `bucket_name` – name for the S3 bucket to create
- `environment` – environment tag (e.g. `dev`, `prod`)
- `role_name`, `policy_name`, `extra_policy_name` – IAM role and policy names
- `trusted_account_arn`, `pipeline_role_arn` – Finomics-provided ARNs (pre-filled)

---

## Modules Breakdown

### Module: `s3/` – Finomics Bucket & Policies

Files: `main.tf`, `variables.tf`, `outputs.tf`

Creates:

- S3 bucket (`aws_s3_bucket.finomics_bucket`) with `force_destroy = true` and versioning enabled.
- Bucket policy allowing cross-account access for pipeline role (`var.pipeline_role_arn`).

Outputs:

- `bucket_name` – the S3 bucket name.

### Module: `iam/` – Finomics Role & Inline Policy

Files: `main.tf`, `variables.tf`, `outputs.tf`

Creates:

- `aws_iam_role.finomics_role` trusting principals from `var.trusted_account_arn` (list of ARNs).
- Inline policy (`aws_iam_role_policy.finomics_policy`) with permissions for:
  - Cost Explorer and Cost Optimization Hub APIs
  - Organizations APIs (read-only)
  - EC2/RDS/AutoScaling/CloudWatch/SSM (descriptive reads)
  - Compute Optimizer (read recommendations)
  - Trusted Advisor (limited checks, subject to Support plan)
  - Finomics Bronze Read-Only (`FinomicsBronzeReadOnly` — broad read access across 40+ services)

Outputs:

- `role_arn` – ARN for the role to be assumed.

Inputs:

- `role_name`, `extra_policy_name`, `trusted_account_arn` (list), `aws_region`, `account_id`.

---

## How to Run

### Prerequisites (Windows PowerShell)

- Terraform >= 1.5.0
- AWS CLI configured with credentials that have permissions to:
  - Create S3 buckets and policies
  - Create IAM roles and inline policies
  - Call Compute Optimizer enrollment (optional)

```powershell
# Option 1: Environment variables (PowerShell)
$env:AWS_ACCESS_KEY_ID = "<YourAccessKey>"
$env:AWS_SECRET_ACCESS_KEY = "<YourSecretKey>"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Option 2: Use a profile
aws configure --profile finomics
$env:AWS_PROFILE = "finomics"
```

### Initialize, Validate, Plan, Apply

```powershell
Set-Location "c:\Users\Raj Jaiswal\Downloads\aws-terra\herbalife-terraform-code\AWS\finomics-infra-tf-code\finomics-tf-config"

terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

---

## What Happens on Apply

1. S3 bucket is created with versioning and bucket policy for pipeline role cross-account access.
2. IAM role (`finomics_role`) is created along with its inline read-focused policy.
3. Compute Optimizer enrollment runs via AWS CLI local-exec (if credentials permit).

---

## Outputs

From the root config:

- `bucket_name` – S3 bucket name.
- `role_arn` – ARN of the IAM role used for Finomics access.

```powershell
terraform output bucket_name
terraform output role_arn

# Export all outputs
terraform output -json > aws_outputs.json
```

---

## Troubleshooting

- Missing AWS credentials

  - Ensure env vars or `AWS_PROFILE` are set and valid.
  - Verify with `aws sts get-caller-identity`.
- Compute Optimizer enrollment fails

  - AWS CLI not installed or insufficient permissions for `compute-optimizer:UpdateEnrollmentStatus`.
  - Either remove the `null_resource` or run with elevated permissions.
- IAM propagation delay

  - Wait 30–90 seconds; re-run read operations.

---

## Security Best Practices

- Enable bucket versioning (enabled in S3 bucket).
- Consider adding server-side encryption and lifecycle rules to S3 buckets.
- Follow least privilege: restrict principals and actions in IAM policies.
- Rotate roles and audit policies periodically.

---

## Next Steps

- Replace `null_resource` enrollment with a provider-native resource if available.
- Add lifecycle policies for data retention on S3 buckets.
- Add KMS encryption for buckets and policies as required by compliance.
