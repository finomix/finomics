# GCP Terraform Infrastructure as Code

Complete Terraform configuration for provisioning Google Cloud Platform (GCP) infrastructure with BigQuery datasets, service accounts, and organization-level permissions for the Herbalife Finomics platform.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Deployment Guide](#deployment-guide)
- [Outputs](#outputs)
- [Permissions & Security](#permissions--security)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## Overview

This Terraform project automates the provisioning of a complete GCP infrastructure setup including:

- **BigQuery Dataset**: Creation and management of BigQuery datasets for billing and analytics data
- **Service Account**: Creation of service accounts with granular permissions
- **Organization-Level Permissions**: Setup of organization-wide access controls and roles
- **Project-Level IAM**: Configuration of project-specific roles and permissions
- **API Management**: Automatic enablement of required GCP APIs

### Key Features

✅ Modular architecture with reusable components
✅ Organization-level permission management
✅ Secure service account configuration
✅ BigQuery dataset creation and access control
✅ State file management via GCS backend
✅ Terraform >= 1.5.0 support
✅ Google Provider v5.0+ compatibility

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│           GCP Project (devops-internal)              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │  Module 1: API Enablement                    │  │
│  │  - Enables required GCP APIs                 │  │
│  └──────────────────────────────────────────────┘  │
│                        ▼                            │
│  ┌──────────────────────────────────────────────┐  │
│  │  Module 2: BigQuery Resources                │  │
│  │  - Creates BigQuery Dataset                  │  │
│  │  - Manages IAM bindings for dataset          │  │
│  └──────────────────────────────────────────────┘  │
│                        ▼                            │
│  ┌──────────────────────────────────────────────┐  │
│  │  Module 3: Service Account                   │  │
│  │  - Creates Service Account                   │  │
│  │  - Grants Org-level permissions              │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
         ▼
┌─────────────────────────────────────────────────────┐
│        Organization Level (ID: 651920494464)        │
├─────────────────────────────────────────────────────┤
│  • roles/browser                                    │
│  • roles/billing.viewer                             │
│  • roles/monitoring.viewer                          │
│  • roles/logging.viewer                             │
│  • roles/recommender.viewer                         │
│  • roles/apigee.analyticsViewer                     │
│  • roles/apigee.readOnlyAdmin                       │
│  • custom_viewer_role_new (76 granular permissions) │
└─────────────────────────────────────────────────────┘
```

---

## Prerequisites

### Required Software
- **Terraform**: >= 1.5.0
- **Google Cloud SDK**: Latest version installed and configured
- **Authentication**: GCP credentials configured locally

### GCP Requirements
- Active GCP Project
- Organization access (for org-level permissions)
- Appropriate IAM permissions to:
  - Create service accounts
  - Enable APIs
  - Create BigQuery datasets
  - Manage IAM bindings
  - Access organization resources

### GCS Backend
- GCS bucket for Terraform state: `gcs-herbalife-statefile-bucket-new`
- Bucket should be created before running Terraform

### Installation Steps

1. **Install Terraform**
   ```bash
   # macOS using Homebrew
   brew install terraform
   
   # Windows using Chocolatey
   choco install terraform
   
   # Or download from https://www.terraform.io/downloads.html
   ```

2. **Install Google Cloud SDK**
   ```bash
   # Follow instructions at https://cloud.google.com/sdk/docs/install
   ```

3. **Configure GCP Authentication**
   ```bash
   gcloud auth application-default login
   # Or set GOOGLE_APPLICATION_CREDENTIALS environment variable
   ```

---

## Directory Structure

```
GCP/
├── README.md                           # This file - Project documentation
├── GCP_PERMISSIONS.md                  # Detailed permission reference
├── .gitignore                          # Git ignore rules
├── .terraform/                         # Terraform working directory (auto-generated)
├── .terraform.lock.hcl                 # Dependency lock file
├── terraform.tfvars                    # Configuration values
├── main.tf                             # Root module - orchestrates all modules
├── variables.tf                        # Root module input variables
├── outputs.tf                          # Root module outputs
├── backend.tf                          # Terraform backend configuration (GCS)
│
└── modules/                            # Reusable Terraform modules
    │
    ├── api_enable/                     # API Enablement Module
    │   ├── main.tf                     # Enable required GCP APIs
    │   └── variables.tf                # Module input variables
    │
    ├── bigquery_resources/             # BigQuery Module
    │   ├── main.tf                     # Create BigQuery dataset and IAM bindings
    │   ├── outputs.tf                  # Module outputs
    │   └── variables.tf                # Module input variables
    │
    └── service_account/                # Service Account Module
        ├── main.tf                     # Create service account and org permissions
        ├── outputs.tf                  # Module outputs
        └── variables.tf                # Module input variables
```

---

## File Descriptions

### Root Files

#### `main.tf`
Orchestrates the three core modules:
- **Module 1**: API Enablement - enables required GCP APIs
- **Module 2**: BigQuery - creates dataset and manages access
- **Module 3**: Service Account - creates SA and grants permissions
- Additional resource blocks for project-level IAM permissions

#### `variables.tf`
Defines all input variables for the root module:
- `project_id` - GCP Project ID
- `region` - Default GCP region
- `organization_id` - Organization ID for org-level permissions
- `dataset_id` - BigQuery dataset ID
- `dataset_location` - BigQuery dataset location
- `dataset_description` - Dataset description
- `delete_contents_on_destroy` - Safety flag for dataset deletion
- `sa_name` - Service account ID
- `sa_display_name` - Service account display name

#### `outputs.tf`
Exports important values after infrastructure creation:
- `dataset_id` - Dataset ID reference
- `dataset_full_id` - Full qualified dataset ID (project:dataset)
- `service_account_email` - Service account email address
- `permissions_summary` - Complete summary of all permissions granted

#### `backend.tf`
Terraform state file configuration:
- **Type**: GCS (Google Cloud Storage)
- **Bucket**: `gcs-herbalife-statefile-bucket-new`
- **Path**: `terraform/state`

### Modules

#### `modules/api_enable/`
Enables required GCP APIs for the project.

**APIs Enabled**:
- `bigquery.googleapis.com` - BigQuery API
- `bigquerydatatransfer.googleapis.com` - BigQuery Data Transfer
- `recommender.googleapis.com` - Google Cloud Recommender
- `cloudresourcemanager.googleapis.com` - Cloud Resource Manager
- `cloudbilling.googleapis.com` - Cloud Billing
- `cloudidentity.googleapis.com` - Cloud Identity

#### `modules/bigquery_resources/`
Creates and manages BigQuery datasets with IAM controls.

**Resources Created**:
- BigQuery Dataset
- Dataset IAM bindings for service accounts
- Configurable access control per dataset

#### `modules/service_account/`
Creates service accounts and grants multi-level permissions.

**Resources Created**:
- Google Service Account
- Organization-level IAM bindings (7 predefined roles + 1 custom role)
- 76 granular permissions in custom viewer role

---

## Getting Started

### 1. Clone or Download the Project
```bash
cd herbalife-terraform-code/GCP
```

### 2. Initialize Terraform
```bash
terraform init
```

**Output**: 
- Downloads required providers (Google, Local)
- Initializes backend (GCS)
- Creates `.terraform/` directory

### 3. Review the Configuration
```bash
# View the variables file
cat terraform.tfvars

# View the planned changes
terraform plan
```

### 4. Review and Adjust Variables
Edit `terraform.tfvars` with your specific values:
```hcl
project_id              = "your-gcp-project-id"
region                  = "us-central1"  # or your preferred region
organization_id         = "your-org-id"
dataset_id              = "your_dataset_name"
sa_name                 = "your-sa-name"
sa_display_name         = "Your SA Display Name"
```

---

## Configuration

### Input Variables

| Variable | Type | Required | Description | Example |
|----------|------|----------|-------------|---------|
| `project_id` | string | Yes | GCP Project ID | `devops-internal-439011` |
| `region` | string | Yes | GCP Region | `us-central1` |
| `organization_id` | string | Yes | GCP Organization ID | `651920494464` |
| `dataset_id` | string | Yes | BigQuery Dataset ID | `sample_testing_dataset_new` |
| `dataset_location` | string | No | Dataset Location | `US` |
| `dataset_description` | string | No | Dataset Description | `Dataset for finomics data` |
| `delete_contents_on_destroy` | bool | No | Delete dataset on destroy | `false` |
| `sa_name` | string | Yes | Service Account ID | `finomics-reader-sa` |
| `sa_display_name` | string | No | SA Display Name | `Finomics Reader` |

### terraform.tfvars Example
```hcl
# GCP Project Configuration
project_id = "devops-internal-439011"
region     = "us-central1"

# Organization Configuration
organization_id = "651920494464"

# BigQuery Dataset Configuration
dataset_id                 = "sample_testing_dataset_new"
dataset_location           = "US"
dataset_description        = "Dataset for finomics billing and analytics data."
delete_contents_on_destroy = false

# Service Account Configuration
sa_name          = "finomics-reader-sa-v2-new"
sa_display_name  = "Finomics Dataset Reader Service Account v2"
```

---

## Deployment Guide

### Step 1: Validate Configuration
```bash
# Check syntax and configuration validity
terraform validate

# Expected output: Success! The configuration is valid.
```

### Step 2: Plan the Deployment
```bash
# Generate execution plan
terraform plan

# Optional: Save plan to file
terraform plan -out=tfplan
```

**Review Output**:
- Resources to be created
- IAM bindings
- Service account details

### Step 3: Apply the Configuration
```bash
# Apply the plan
terraform apply

# Or apply previously saved plan
terraform apply tfplan

# Confirm with 'yes' when prompted
```

**Expected Resources Created**:
- 1x Service Account
- 1x BigQuery Dataset
- 8x Organization IAM bindings
- 3x Project IAM bindings
- 1x Custom Organization Role

### Step 4: Verify Deployment
```bash
# Check outputs
terraform output

# Get service account email
terraform output service_account_email

# Get permissions summary
terraform output permissions_summary
```

### Destroying Infrastructure

⚠️ **WARNING**: Destroy operation is irreversible.

```bash
# Plan the destruction
terraform plan -destroy

# Destroy all resources
terraform destroy

# Confirm with 'yes' when prompted
```

**Note**: 
- Set `delete_contents_on_destroy = true` to remove dataset contents
- Service account key files (if created) must be deleted separately
- Organization roles remain if not dependent on other resources

---

## Outputs

After successful `terraform apply`, the following outputs are available:

### Output Values

```bash
terraform output
```

**Example Output**:
```
dataset_full_id = "devops-internal-439011:sample_testing_dataset_new"
dataset_id = "sample_testing_dataset_new"

service_account_email = "finomics-reader-sa-v2-new@devops-internal-439011.iam.gserviceaccount.com"

permissions_summary = {
  "bigquery_dataset_access" = "roles/bigquery.dataViewer on sample_testing_dataset_new"
  "bigquery_project_dataviewer" = "roles/bigquery.dataViewer on project devops-internal-439011"
  "bigquery_project_jobuser" = "roles/bigquery.jobUser on project devops-internal-439011"
  "bigquery_project_readsession" = "roles/bigquery.readSessionUser on project devops-internal-439011"
  "organization_apigee_analytics" = "roles/apigee.analyticsViewer on org 651920494464"
  "organization_apigee_readonly" = "roles/apigee.readOnlyAdmin on org 651920494464"
  "organization_billing" = "roles/billing.viewer on org 651920494464"
  "organization_browser" = "roles/browser on org 651920494464"
  "organization_custom_viewer" = "custom_viewer_role_new on org 651920494464"
  "organization_logs_viewer" = "roles/logging.viewer on org 651920494464"
  "organization_monitoring" = "roles/monitoring.viewer on org 651920494464"
  "organization_recommender" = "roles/recommender.viewer on org 651920494464"
}
```

---

## Permissions & Security

### Organization-Level Permissions

The service account is granted the following organization-level roles:

| Role | Purpose |
|------|---------|
| `roles/browser` | Basic read-only access to browse resources |
| `roles/billing.viewer` | View billing data and cost analysis |
| `roles/monitoring.viewer` | View monitoring metrics and dashboards |
| `roles/logging.viewer` | View Cloud Logging and audit logs |
| `roles/recommender.viewer` | View optimization recommendations |
| `roles/apigee.analyticsViewer` | View Apigee API analytics |
| `roles/apigee.readOnlyAdmin` | Read-only Apigee administration |
| `custom_viewer_role_new` | 76 granular read-only permissions across 13 GCP services |

**Detailed permission breakdown**: See [GCP_PERMISSIONS.md](GCP_PERMISSIONS.md)

### Project-Level Permissions

| Role | Purpose | Scope |
|------|---------|-------|
| `roles/bigquery.dataViewer` | Read BigQuery datasets and tables | Dataset-level |
| `roles/bigquery.jobUser` | Create and run BigQuery jobs | Project-level |
| `roles/bigquery.readSessionUser` | Create read sessions for efficient data reading | Project-level |

### Security Best Practices

✅ **Implemented**:
- Service accounts use minimal required permissions
- All permissions are read-only (no modification capabilities)
- No service account keys created by Terraform (keys created manually as needed)
- Organization-level permissions properly scoped
- Dataset access restricted to specific dataset

⚠️ **Recommendations**:
- Rotate service account keys regularly
- Monitor service account usage via Cloud Audit Logs
- Restrict service account impersonation permissions
- Use Workload Identity in GKE if running on Kubernetes
- Store service account key files securely (use Secret Manager)

---

## Troubleshooting

### Common Issues

#### 1. **Authentication Error: "permission denied"**
```
Error: Error creating Service Account: googleapi: Error 403
```

**Solution**:
```bash
# Verify authentication
gcloud auth list

# Re-authenticate if needed
gcloud auth application-default login

# Or set explicit credentials
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/keyfile.json"
```

#### 2. **Backend Initialization Failed**
```
Error: Error reading gcs backend config: Google Cloud Storage bucket 
'gcs-herbalife-statefile-bucket-new' does not exist
```

**Solution**:
```bash
# Create the GCS bucket for state
gsutil mb gs://gcs-herbalife-statefile-bucket-new

# Or disable remote backend temporarily
terraform init -backend=false
```

#### 3. **API Not Enabled Error**
```
Error: API bigquery.googleapis.com is not enabled
```

**Solution**:
```bash
# Enable APIs manually
gcloud services enable bigquery.googleapis.com

# Or modify terraform.tfvars to include required APIs
```

#### 4. **Organization ID Not Found**
```
Error: Error setting organization policy: Error 404: Organization 651920494464 not found
```

**Solution**:
- Verify organization ID: `gcloud organizations list`
- Ensure you have access to the organization
- Update `organization_id` in `terraform.tfvars`

#### 5. **State File Lock**
```
Error: Error acquiring the state lock: ... Locked by another process
```

**Solution**:
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID

# Or wait for other process to complete
```

### Debugging

Enable debug logging:
```bash
# Terraform debug
export TF_LOG=DEBUG
terraform plan

# Google provider debug
export GOOGLE_SDK_GO_LOGGING_LEVEL=debug
```

### Useful Commands

```bash
# Show current state
terraform state list
terraform state show module.service_account

# Show resource details in GCP
gcloud iam service-accounts list
gcloud bigquery datasets list

# Check IAM bindings
gcloud organizations get-iam-policy 651920494464
gcloud projects get-iam-policy devops-internal-439011

# Validate Terraform syntax
terraform fmt -recursive .
terraform validate
```

---

## Additional Resources

### Documentation
- [Terraform Google Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Google Cloud Platform Documentation](https://cloud.google.com/docs)
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [Service Accounts Documentation](https://cloud.google.com/iam/docs/service-accounts)

### Related Files
- [GCP_PERMISSIONS.md](GCP_PERMISSIONS.md) - Detailed permission reference
- `terraform.tfvars` - Configuration values for your environment
- `.terraform.lock.hcl` - Provider version lock file

### Support & Feedback
For issues, questions, or contributions:
- Check the [Troubleshooting](#troubleshooting) section
- Review Terraform state: `terraform show`
- Check GCP audit logs for API errors
- Consult Google Cloud documentation

---

## Version Information

- **Terraform Version**: >= 1.5.0
- **Google Provider Version**: ~> 5.0 (tested with 5.45.2)
- **Local Provider Version**: 2.9.0
- **Created**: 2025
- **Last Updated**: 2026-05-28

---

## License

This Terraform configuration is part of the Herbalife Infrastructure as Code project.

---

## Quick Reference

### Common Commands

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive .

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Show outputs
terraform output

# Show state
terraform state list

# Destroy infrastructure
terraform destroy

# Specific resource operations
terraform plan -target=module.service_account
terraform destroy -target=google_bigquery_dataset.dataset
```

### Important Files to Review

1. **Start Here**: This README.md
2. **Permissions**: GCP_PERMISSIONS.md
3. **Configuration**: terraform.tfvars
4. **Main Logic**: main.tf
5. **Modules**: modules/*/main.tf

---

**For detailed permission information, see [GCP_PERMISSIONS.md](GCP_PERMISSIONS.md)**
