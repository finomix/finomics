# Finomics Client Setup

This repository contains all the infrastructure code and configuration files clients need to connect their cloud, SaaS, and PaaS platforms to [Finomics](https://finomics.ai) — an Intelligent FinOps platform providing real-time control and clarity across your entire Cloud, SaaS & PaaS ecosystem.

## Contents

| Directory | Platform | Description |
|-----------|----------|-------------|
| [aws/child-account-role-tf/](aws/child-account-role-tf/) | AWS | Terraform module to create an IAM role granting Finomics read-only access to a child AWS account |

> More platform integrations (SaaS, PaaS, additional cloud providers) will be added here over time.

---

## AWS — Child Account IAM Role

### Overview

Finomics requires read-only access to your AWS accounts to collect cost, usage, and resource data. This Terraform module creates an IAM role in your child account that trusts the Finomics data pipeline to assume it — no credentials are shared.

The role grants read-only access across 28+ AWS services including Cost Explorer, EC2, RDS, S3, Lambda, CloudWatch, and more.

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured with credentials for the target child account
- An S3 bucket in your account to store Terraform state (or use a different [backend](https://developer.hashicorp.com/terraform/language/backend))

### Setup

**1. Clone this repository**

```bash
git clone https://github.com/your-org/finomics.git
cd finomics/aws/child-account-role-tf
```

**2. Configure the backend**

Edit [backend.tf](aws/child-account-role-tf/backend.tf) and fill in your S3 bucket details:

```hcl
terraform {
  backend "s3" {
    bucket = "<your-terraform-state-bucket>"
    key    = "<path/to/state/file.tfstate>"
    region = "us-east-1"
  }
}
```

**3. Configure the module inputs**

Edit [main.tf](aws/child-account-role-tf/main.tf) and fill in the required values:

```hcl
module "finomics_child_role" {
  source = "./modules"

  role_name       = "<role-name-provided-by-finomics>"
  account_id      = "<your-aws-account-id>"

  # Pre-filled by Finomics — do not change
  trusted_account = "364582896484"
  trusted_role_arn = "arn:aws:iam::364582896484:role/finomics_data_pipeline_role"
}
```

**4. Apply**

```bash
terraform init
terraform plan
terraform apply
```

**5. Share the role ARN with Finomics**

After a successful apply, Terraform will output the ARN of the created role. Provide this ARN to the Finomics team to complete the integration.

```bash
terraform output role_arn
```

### Module Inputs

| Variable | Description |
|----------|-------------|
| `role_name` | Name of the IAM role to create (provided by Finomics) |
| `account_id` | Your AWS child account ID |
| `trusted_account` | Finomics AWS account ID (pre-filled) |
| `trusted_role_arn` | Finomics role ARN allowed to assume this role (pre-filled) |

### Module Outputs

| Output | Description |
|--------|-------------|
| `role_arn` | ARN of the created IAM role |

---

## License

MIT — see [LICENSE](LICENSE) for details.
