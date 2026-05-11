# Finomics Client Onboarding

This repository contains the onboarding scripts and infrastructure-as-code that clients use to connect their cloud, SaaS, and PaaS platforms to [Finomics](https://finomics.ai) — an Intelligent FinOps platform providing real-time control and clarity across your entire Cloud, SaaS & PaaS ecosystem.

Each directory is a self-contained setup for a specific platform. Pick the integrations you need, follow the README inside that directory, and share the resulting outputs (role ARNs, bucket names, etc.) with the Finomics team to complete onboarding.

## Available Integrations

| Directory | Platform | Description |
|-----------|----------|-------------|
| [aws-tf-client-setup/](aws-tf-client-setup/) | AWS | Terraform configuration that provisions an S3 bucket for FOCUS exports and an IAM role granting Finomics cross-account read-only access. See [AWS Terraform Complete Guide](aws-tf-client-setup/AWS_TERRAFORM_COMPLETE_GUIDE.md) and [IAM Permissions Reference](aws-tf-client-setup/IAM_PERMISSIONS_REFERENCE.md). |

> More platform integrations (additional clouds, SaaS, and PaaS providers) will be added here over time.

## How It Works

Finomics never asks for long-lived credentials. Each integration in this repo follows the same pattern:

1. You run the provided IaC in your own account.
2. It creates a least-privilege role that trusts a Finomics-owned principal to assume it.
3. You share the resulting resource identifiers (role ARN, bucket name, subscription ID, etc.) with Finomics.
4. The Finomics data pipeline assumes the role on a schedule to pull cost, usage, and resource metadata.

No credentials leave your environment.

## Getting Started

1. Choose the platform you want to onboard from the table above.
2. Open the README inside that directory and follow its setup steps.
3. Apply the Terraform (or other IaC) using credentials for the target account.
4. Send the outputs to the Finomics team to complete the integration.

## Prerequisites

Most integrations require:

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- A CLI for the target platform (AWS CLI, Azure CLI, etc.) configured with credentials that can create IAM roles/policies and storage resources
- A remote state backend (e.g. an S3 bucket for AWS) — see each integration's README for details

## Support

For onboarding questions or to register the outputs from your setup, contact the Finomics team.

## License

MIT — see [LICENSE](LICENSE) for details.
