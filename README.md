# Finomics AWS Terraform Infrastructure

This Terraform configuration provisions the AWS infrastructure required for Finomics to collect cost and usage data from your AWS Organization. It runs in the **management account** and covers:

- A central **S3 bucket** to receive FOCUS data exports from all accounts in the Organization
- A cross-account **IAM role** with read-only permissions that Finomics assumes to analyze your cloud spend
- **Compute Optimizer** enrollment via a local-exec provisioner
- Remote **Terraform state** stored in S3

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Directory Structure](#directory-structure)
4. [Resources Created](#resources-created)
5. [Variable Reference](#variable-reference)
6. [terraform.tfvars Configuration](#terraformtfvars-configuration)
7. [Backend Configuration](#backend-configuration)
8. [IAM Role & Permissions](#iam-role--permissions)
9. [S3 Bucket & Bucket Policy](#s3-bucket--bucket-policy)
10. [FOCUS Data Export Setup](#focus-data-export-setup)
11. [CI/CD Pipeline (Azure Pipelines)](#cicd-pipeline-azure-pipelines)
12. [Outputs](#outputs)
13. [How to Run](#how-to-run)
14. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    AWS Organization (o-ri54766xyn)               │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              Management Account (<your-account-id>)      │    │
│  │                                                           │    │
│  │   ┌─────────────────────┐   ┌────────────────────────┐  │    │
│  │   │   S3 Bucket          │   │   IAM Role              │  │    │
│  │   │  finomics-s3-bucket  │   │  finomics-access-role   │  │    │
│  │   │                      │   │                          │  │    │
│  │   │  focus-exports/      │   │  Trusted by:             │  │    │
│  │   │  ├─ focus-daily/     │   │  364582896484 (Finomics) │  │    │
│  │   │  ├─ focus-monthly/   │   │                          │  │    │
│  │   │  └─ historical-data/ │   │                          │  │    │
│  │   └──────────┬───────────┘   └────────────┬───────────┘  │    │
│  │              │                             │               │    │
│  └──────────────┼─────────────────────────────┼──────────────┘    │
│                 │                             │                    │
│  ┌──────────────▼──────────────┐             │                    │
│  │  Child Accounts (all org)    │             │                    │
│  │  Write FOCUS exports via     │             │                    │
│  │  bcm-data-exports.amazonaws  │             │                    │
│  │  .com or direct IAM write    │             │                    │
│  └─────────────────────────────┘             │                    │
│                                               │                    │
└───────────────────────────────────────────────┼────────────────────┘
                                                │
                              ┌─────────────────▼──────────────┐
                              │   Finomics Account (364582896484)│
                              │                                   │
                              │   finomics_data_pipeline_role     │
                              │   assumes the IAM role above to   │
                              │   read cost & usage data          │
                              └───────────────────────────────────┘
```

---

## Prerequisites

- Terraform >= 1.5.7
- AWS CLI configured with credentials for the **management account**
- The management account must be the **Organization master/management account**
- IAM permissions to create: S3 buckets, IAM roles, IAM policies
- (Optional) Permission to call `compute-optimizer:UpdateEnrollmentStatus` for Compute Optimizer enrollment

---

## Directory Structure

```
finomics-infra-tf-code/
├── azure-pipelines.yml             # CI/CD pipeline definition
├── .gitignore
├── finomix-tf-config/              # Root configuration — entry point for Terraform
│   ├── backend.tf                  # Remote S3 state backend
│   ├── main.tf                     # Module orchestration
│   ├── outputs.tf                  # Root-level outputs
│   ├── provider.tf                 # AWS provider
│   ├── terraform.tfvars            # Variable values (environment-specific)
│   └── variables.tf                # Variable declarations
└── finomix-tf-modules/             # Reusable modules
    ├── iam/                        # IAM role + inline policy
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── s3/                         # S3 bucket + bucket policy + folder prefixes
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

---

## Resources Created

| Resource | Type | Description |
|---|---|---|
| `finomics-s3-bucket` | `aws_s3_bucket` | Central S3 bucket in the management account for FOCUS data exports |
| S3 public access block | `aws_s3_bucket_public_access_block` | Blocks all public access to the bucket |
| S3 versioning | `aws_s3_bucket_versioning` | Enables object versioning |
| S3 bucket policy | `aws_s3_bucket_policy` | Org-wide write access + pipeline role read access |
| `focus-exports/focus-daily/` | `aws_s3_object` | Folder prefix for daily FOCUS exports |
| `focus-exports/focus-monthly/` | `aws_s3_object` | Folder prefix for monthly FOCUS exports |
| `focus-exports/historical-data/` | `aws_s3_object` | Folder prefix for historical FOCUS exports |
| `finomics-access-role` | `aws_iam_role` | Cross-account role assumed by Finomics |
| `iam-terraform-onboarding-policies` | `aws_iam_role_policy` | Inline policy attached to the role |
| Compute Optimizer enrollment | `null_resource` | Activates AWS Compute Optimizer via local-exec |

---

## Variable Reference

| Variable | Description | Default |
|---|---|---|
| `aws_region` | AWS region to deploy resources | `us-east-1` |
| `account_id` | Management account ID | — (required) |
| `org_id` | AWS Organizations ID (e.g. `o-xxxxxxxxxx`) | — (required) |
| `bucket_name` | S3 bucket name for FOCUS exports | `finomics-s3-bucket` |
| `environment` | Deployment environment tag | `dev` |
| `role_name` | IAM role name for Finomics access | `finomics-access-role` |
| `trusted_account_arn` | List of Finomics account/role ARNs allowed to assume the role | — (required) |
| `pipeline_role_arn` | Finomics pipeline role ARN — granted S3 read access | — (required) |
| `policy_name` | Name for the IAM access policy | `finomics-access-policy` |
| `extra_policy_name` | Name for the inline IAM permissions policy | `iam-terraform-onboarding-policies` |

---

## terraform.tfvars Configuration

Update `finomix-tf-config/terraform.tfvars` with values for your environment:

```hcl
# AWS Configuration
aws_region = "us-east-1"
account_id = "<your-account-id>"

# AWS Organizations ID
# Find it via: aws organizations describe-organization --query 'Organization.Id' --output text
org_id = "o-ri54766xyn"

# S3 Bucket for FOCUS exports (central bucket in management account)
bucket_name = "finomics-s3-bucket"

# Environment tag
environment = "dev"

# IAM Role name created in this account for Finomics to assume
role_name = "finomics-access-role"

# Finomics account ARNs that are allowed to assume the IAM role
trusted_account_arn = [
  "arn:aws:iam::364582896484:role/finomics_data_pipeline_role"
]

# Finomics pipeline role — granted read access to the S3 bucket
pipeline_role_arn = "arn:aws:iam::364582896484:role/finomics_data_pipeline_role"

# IAM Policy names
policy_name       = "finomics-access-policy"
extra_policy_name = "iam-terraform-onboarding-policies"
```

> **Note:** The ARNs `arn:aws:iam::364582896484:*` belong to the **Finomics platform account** and must be kept exactly as shown. Only replace `<your-account-id>` with your own management account ID.

---

## Backend Configuration

Terraform state is stored remotely in S3 (`finomix-tf-config/backend.tf`):

```hcl
terraform {
  backend "s3" {
    bucket  = "finomics-aws-terraform-pov-new-statefile"
    key     = "terraform-2/state/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

The state bucket (`finomics-aws-terraform-pov-new-statefile`) must exist in `us-east-1` **before** running `terraform init`. Server-side encryption is enabled.

The pipeline overrides backend values at init time:

```yaml
terraform init \
  -backend-config="bucket=finomics-aws-terraform-pov-new-statefile" \
  -backend-config="key=terraform-2/state/terraform.tfstate" \
  -backend-config="region=us-east-1"
```

---

## IAM Role & Permissions

### Role Trust Policy

The role `finomics-access-role` trusts the following Finomics ARNs to assume it:

| Principal | Account |
|---|---|
| `arn:aws:iam::364582896484:role/finomics_data_pipeline_role` | Finomics platform (364582896484) |

### Inline Policy Statements

The attached inline policy (`iam-terraform-onboarding-policies`) contains the following permission groups:

#### 1. CostExplorerAndOrgAPIs — `Resource: *`

| Service | Actions |
|---|---|
| Cost Explorer | `ce:GetCostAndUsage`, `ce:GetCostForecast`, `ce:GetDimensionValues`, `ce:GetTags`, `ce:ListCostAllocationTags`, `ce:GetRightsizingRecommendation`, `ce:GetSavingsPlansUtilizationDetails`, `ce:GetReservationUtilization` |
| Cost Optimization Hub | `cost-optimization-hub:ListRecommendations`, `cost-optimization-hub:ListRecommendationSummaries`, `cost-optimization-hub:GetPreferences`, `cost-optimization-hub:GetRecommendation` |
| Organizations | `organizations:DescribeOrganization`, `organizations:DescribeAccount`, `organizations:ListAccounts`, `organizations:ListParents`, `organizations:ListAccountsForParent`, `organizations:ListRoots` |

#### 2. EC2Access — `Resource: arn:aws:ec2:<region>:<your-account-id>:instance/*, volume/*`

`ec2:DescribeInstances`, `ec2:DescribeRegions`, `ec2:DescribeVolumes`

#### 3. RDSAccess — `Resource: arn:aws:rds:<region>:<your-account-id>:db:*`

`rds:DescribeDBInstances`

#### 4. AutoScalingAccess — `Resource: arn:aws:autoscaling:<region>:<your-account-id>:autoScalingGroup:*`

`autoscaling:DescribeAutoScalingGroups`, `autoscaling:DescribePolicies`

#### 5. CloudWatchAccess — `Resource: arn:aws:cloudwatch:<region>:<your-account-id>:metric/*`

`cloudwatch:GetMetricStatistics`

#### 6. SSMParameterAccess — `Resource: arn:aws:ssm:<region>:<your-account-id>:parameter/*`

`ssm:GetParameters`

#### 7. ComputeOptimizerAccess — `Resource: arn:aws:compute-optimizer:<region>:<your-account-id>:recommendation/*`

`compute-optimizer:GetEnrollmentStatus`, `compute-optimizer:GetEC2InstanceRecommendations`, `compute-optimizer:GetECSServiceRecommendations`, `compute-optimizer:GetEBSVolumeRecommendations`

#### 8. TrustedAdvisorAccess — `Resource: arn:aws:trustedadvisor:<region>:<your-account-id>:check/*`

`trustedadvisor:DescribeCheckSummaries`, `trustedadvisor:DescribeCheckItems`

#### 9. FinomicsBronzeReadOnly — `Resource: *`

Broad read-only access across 40+ AWS services required for cost analytics:

| Service Group | Actions |
|---|---|
| STS | `sts:GetCallerIdentity` |
| Resource Tagging | `tag:GetResources`, `tag:GetTagKeys`, `tag:GetTagValues` |
| Bedrock | `bedrock:GetFoundationModel`, `bedrock:ListFoundationModels`, `bedrock:ListCustomModels`, `bedrock:GetCustomModel`, `bedrock:GetProvisionedModelThroughput`, `bedrock:ListProvisionedModelThroughputs`, `bedrock:ListTagsForResource`, `bedrock:GetModelInvocationLoggingConfiguration` |
| CloudWatch | `cloudwatch:GetMetricData`, `cloudwatch:GetMetricStatistics`, `cloudwatch:ListMetrics`, `cloudwatch:DescribeAlarms`, `cloudwatch:ListDashboards` |
| CloudWatch Logs | `logs:DescribeLogGroups`, `logs:DescribeLogStreams`, `logs:DescribeMetricFilters` |
| EC2 | `ec2:DescribeInstances`, `ec2:DescribeTags`, `ec2:DescribeVolumes`, `ec2:DescribeSnapshots`, `ec2:DescribeVpcs`, `ec2:DescribeSubnets`, `ec2:DescribeSecurityGroups`, `ec2:DescribeNetworkInterfaces`, `ec2:DescribeRouteTables`, `ec2:DescribeInternetGateways`, `ec2:DescribeNatGateways`, `ec2:DescribeAddresses`, `ec2:DescribeKeyPairs`, `ec2:DescribeAvailabilityZones`, `ec2:DescribeRegions`, `ec2:DescribePlacementGroups`, `ec2:DescribeVpcPeeringConnections`, `ec2:DescribeVpcEndpoints`, `ec2:DescribeReservedInstances`, `ec2:DescribeImages`, `ec2:DescribeInstanceTypes` |
| ACM | `acm:ListCertificates`, `acm:DescribeCertificate` |
| API Gateway | `apigateway:GET` |
| CloudFormation | `cloudformation:ListStacks`, `cloudformation:DescribeStacks`, `cloudformation:ListStackResources`, `cloudformation:DescribeStackResources`, `cloudformation:DescribeStackEvents`, `cloudformation:GetTemplate` |
| CloudFront | `cloudfront:ListDistributions`, `cloudfront:GetDistribution`, `cloudfront:ListFunctions`, `cloudfront:ListCachePolicies`, `cloudfront:ListOriginRequestPolicies`, `cloudfront:ListTagsForResource` |
| CloudTrail | `cloudtrail:ListTrails`, `cloudtrail:GetTrail`, `cloudtrail:DescribeTrails`, `cloudtrail:GetTrailStatus`, `cloudtrail:GetEventSelectors`, `cloudtrail:ListTags` |
| Config | `config:DescribeConfigurationRecorders`, `config:DescribeDeliveryChannels`, `config:DescribeConfigRules`, `config:GetComplianceDetailsByConfigRule`, `config:DescribeConfigurationRecorderStatus`, `config:DescribeDeliveryChannelStatus` |
| DeepRacer | `deepracer:ListModels`, `deepracer:GetModel`, `deepracer:ListLeaderboards`, `deepracer:ListTracks`, `deepracer:GetCars`, `deepracer:GetCar` |
| Direct Connect | `directconnect:DescribeConnections`, `directconnect:DescribeVirtualInterfaces`, `directconnect:DescribeDirectConnectGateways`, `directconnect:DescribeLags`, `directconnect:DescribeLocations` |
| DynamoDB | `dynamodb:ListTables`, `dynamodb:DescribeTable`, `dynamodb:ListGlobalTables`, `dynamodb:DescribeGlobalTable`, `dynamodb:DescribeTimeToLive`, `dynamodb:ListBackups`, `dynamodb:ListTagsOfResource` |
| ECR | `ecr:DescribeRepositories`, `ecr:DescribeImages`, `ecr:GetRepositoryPolicy`, `ecr:ListImages`, `ecr:ListTagsForResource` |
| ECS | `ecs:ListClusters`, `ecs:DescribeClusters`, `ecs:ListServices`, `ecs:DescribeServices`, `ecs:ListTasks`, `ecs:DescribeTasks`, `ecs:ListContainerInstances`, `ecs:DescribeContainerInstances` |
| EFS | `elasticfilesystem:DescribeFileSystems`, `elasticfilesystem:DescribeMountTargets`, `elasticfilesystem:DescribeAccessPoints`, `elasticfilesystem:DescribeLifecycleConfiguration` |
| EKS | `eks:ListClusters`, `eks:DescribeCluster`, `eks:ListNodegroups`, `eks:DescribeNodegroup`, `eks:ListAddons`, `eks:DescribeAddon`, `eks:ListFargateProfiles` |
| ElastiCache | `elasticache:DescribeCacheClusters`, `elasticache:DescribeReplicationGroups`, `elasticache:DescribeCacheSubnetGroups`, `elasticache:DescribeCacheParameterGroups`, `elasticache:ListTagsForResource` |
| ELB | `elasticloadbalancing:DescribeLoadBalancers`, `elasticloadbalancing:DescribeTargetGroups`, `elasticloadbalancing:DescribeListeners`, `elasticloadbalancing:DescribeRules`, `elasticloadbalancing:DescribeTags`, `elasticloadbalancing:DescribeTargetHealth` |
| Elasticsearch / OpenSearch | `es:ListDomainNames`, `es:DescribeElasticsearchDomains`, `es:DescribeElasticsearchDomain`, `es:ListTags` |
| Location (Geo) | `geo:ListPlaceIndexes`, `geo:ListMaps`, `geo:ListRouteCalculators`, `geo:ListTrackers`, `geo:ListGeofenceCollections`, `geo:DescribeMap`, `geo:DescribeTracker`, `geo:DescribePlaceIndex`, `geo:DescribeRouteCalculator` |
| Glacier | `glacier:ListVaults`, `glacier:DescribeVault`, `glacier:ListJobs`, `glacier:GetVaultNotifications` |
| Glue | `glue:GetJobs`, `glue:GetJob`, `glue:GetDatabases`, `glue:GetTables`, `glue:GetCrawlers`, `glue:GetCrawler`, `glue:GetConnections`, `glue:GetDevEndpoints`, `glue:GetTriggers` |
| GuardDuty | `guardduty:ListDetectors`, `guardduty:GetDetector`, `guardduty:ListFindings`, `guardduty:GetFindings`, `guardduty:ListMembers`, `guardduty:GetMasterAccount` |
| KMS | `kms:ListKeys`, `kms:DescribeKey`, `kms:ListAliases`, `kms:GetKeyPolicy`, `kms:ListKeyPolicies`, `kms:ListResourceTags` |
| Lambda | `lambda:ListFunctions`, `lambda:GetFunction`, `lambda:GetFunctionConfiguration`, `lambda:ListEventSourceMappings`, `lambda:ListAliases`, `lambda:ListVersionsByFunction`, `lambda:ListTags` |
| Payment Cryptography | `payment-cryptography:ListKeys`, `payment-cryptography:GetKey`, `payment-cryptography:ListTagsForResource` |
| RDS | `rds:DescribeDBInstances`, `rds:DescribeDBClusters`, `rds:DescribeDBSnapshots`, `rds:DescribeDBSubnetGroups`, `rds:DescribeDBParameterGroups`, `rds:ListTagsForResource` |
| Route 53 | `route53:ListHostedZones`, `route53:GetHostedZone`, `route53:ListResourceRecordSets`, `route53:ListHealthChecks`, `route53:GetHealthCheck`, `route53:ListQueryLoggingConfigs` |
| Route 53 Domains | `route53domains:ListDomains`, `route53domains:GetDomainDetail` |
| S3 | `s3:ListAllMyBuckets`, `s3:ListBucket`, `s3:GetObject`, `s3:GetBucketLocation`, `s3:GetEncryptionConfiguration`, `s3:GetBucketVersioning`, `s3:GetBucketTagging`, `s3:GetBucketLogging`, `s3:GetLifecycleConfiguration`, `s3:GetBucketPublicAccessBlock`, `s3:GetBucketAcl`, `s3:GetBucketPolicy`, `s3:GetBucketPolicyStatus`, `s3:GetBucketNotification`, `s3:GetReplicationConfiguration` |
| Secrets Manager | `secretsmanager:ListSecrets`, `secretsmanager:DescribeSecret` |
| Security Hub | `securityhub:GetFindings`, `securityhub:DescribeHub`, `securityhub:ListEnabledProductsForImport`, `securityhub:GetInsights`, `securityhub:DescribeStandards` |
| SNS | `sns:ListTopics`, `sns:GetTopicAttributes`, `sns:ListSubscriptionsByTopic`, `sns:ListSubscriptions`, `sns:ListTagsForResource` |
| SQS | `sqs:ListQueues`, `sqs:GetQueueAttributes`, `sqs:ListQueueTags` |
| SSM | `ssm:DescribeInstanceInformation`, `ssm:DescribeParameters`, `ssm:ListDocuments`, `ssm:GetInventory`, `ssm:DescribePatchBaselines`, `ssm:ListAssociations` |
| Step Functions | `states:ListStateMachines`, `states:DescribeStateMachine`, `states:ListExecutions`, `states:DescribeExecution`, `states:ListActivities`, `states:ListTagsForResource` |
| Support / Trusted Advisor | `support:DescribeCases`, `support:DescribeTrustedAdvisorChecks`, `support:DescribeTrustedAdvisorCheckResult`, `support:DescribeTrustedAdvisorCheckSummaries`, `support:DescribeSeverityLevels` |
| WAF | `waf:ListWebACLs`, `waf:GetWebACL`, `waf-regional:ListWebACLs`, `waf-regional:GetWebACL`, `wafv2:ListWebACLs`, `wafv2:GetWebACL`, `wafv2:ListRuleGroups`, `wafv2:GetRuleGroup`, `wafv2:ListTagsForResource` |

---

## S3 Bucket & Bucket Policy

### Bucket Configuration

| Property | Value |
|---|---|
| Bucket name | `finomics-s3-bucket` |
| Versioning | Enabled |
| Public access | Fully blocked |
| Force destroy | Enabled (allows Terraform to delete non-empty bucket) |

### Folder Structure

```
finomics-s3-bucket/
└── focus-exports/
    ├── focus-daily/       ← Daily FOCUS export data
    ├── focus-monthly/     ← Monthly FOCUS export data
    └── historical-data/   ← Historical FOCUS export data
```

### Bucket Policy Statements

| Sid | Principal | Actions | Condition |
|---|---|---|---|
| `AllowFocusDataExportWrite` | `bcm-data-exports.amazonaws.com` | `s3:PutObject` | `aws:SourceOrgID = o-ri54766xyn` |
| `AllowFocusDataExportGetPolicy` | `bcm-data-exports.amazonaws.com` | `s3:GetBucketPolicy` | `aws:SourceOrgID = o-ri54766xyn` |
| `AllowOrgAccountsWrite` | `*` (all IAM principals) | `s3:PutObject`, `s3:DeleteObject`, `s3:AbortMultipartUpload` | `aws:PrincipalOrgID = o-ri54766xyn` |
| `AllowOrgAccountsList` | `*` (all IAM principals) | `s3:ListBucket`, `s3:GetBucketLocation` | `aws:PrincipalOrgID = o-ri54766xyn` |
| `AllowPipelineRoleAccess` | `arn:aws:iam::364582896484:role/finomics_data_pipeline_role` | `s3:GetObject`, `s3:ListBucket`, `s3:GetBucketVersioning`, `s3:GetBucketPolicyStatus`, `s3:GetEncryptionConfiguration` | None |

The `aws:SourceOrgID` and `aws:PrincipalOrgID` conditions ensure only accounts within your AWS Organization can interact with this bucket, preventing confused-deputy attacks.

---

## FOCUS Data Export Setup

FOCUS (FinOps Open Cost and Usage Specification) exports are **set up manually** via the AWS Console or CLI — Terraform does not create the export definition itself. It only provisions the destination bucket.

### Steps to configure a FOCUS export

1. Sign in to the **AWS Billing and Cost Management console** in each account you want to export from (or the management account for org-wide)
2. Navigate to **Data Exports** → **Create export**
3. Select **FOCUS 1.0** as the export type
4. Set the **S3 bucket** to `finomics-s3-bucket` (in account `<your-account-id>`)
5. Set the **S3 prefix** to:
   - `focus-exports/focus-daily/` for daily granularity
   - `focus-exports/focus-monthly/` for monthly granularity
6. Complete and save — the bucket policy already permits `bcm-data-exports.amazonaws.com` to write from any org account

> All child accounts in the Organization can write to this bucket because the bucket policy allows all principals with `aws:PrincipalOrgID = o-ri54766xyn`.

---

## CI/CD Pipeline (Azure Pipelines)

The pipeline is defined in `azure-pipelines.yml` and supports three operations controlled by runtime parameters.

### Parameters

| Parameter | Default | Description |
|---|---|---|
| `runPlan` | `true` | Run `terraform plan` |
| `runApply` | `true` | Run `terraform apply` |
| `runDestroy` | `false` | ⚠️ Run `terraform destroy` — destroys all infrastructure |

### Variable Group

The pipeline reads AWS credentials from the Azure DevOps variable group **`aws-creds-terraform-herbalife`**, which must contain:

| Variable | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | Access key for a management account IAM user/role |
| `AWS_SECRET_ACCESS_KEY` | Corresponding secret key |

### Pipeline Stages

```
Terraform Init  →  Terraform Plan  →  Terraform Apply  →  Terraform Destroy
   (always)       (if runPlan)       (if runApply)       (if runDestroy)
```

> **Warning:** `runDestroy` defaults to `false`. Never enable it in a production pipeline run without explicit intent — it will delete the S3 bucket, IAM role, and all associated resources.

---

## Outputs

After a successful `terraform apply`, the following outputs are available:

| Output | Description |
|---|---|
| `bucket_name` | Name of the S3 bucket created for FOCUS exports |
| `role_arn` | Full ARN of the IAM role Finomics will assume — share this with Finomics during onboarding |

```bash
terraform output bucket_name
terraform output role_arn

# Export all as JSON
terraform output -json > aws_outputs.json
```

---

## How to Run

### 1. Configure credentials

```bash
# Option A: environment variables
export AWS_ACCESS_KEY_ID="<your-access-key>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key>"
export AWS_DEFAULT_REGION="us-east-1"

# Option B: named profile
aws configure --profile finomics-mgmt
export AWS_PROFILE=finomics-mgmt
```

### 2. Update terraform.tfvars

Edit `finomix-tf-config/terraform.tfvars` and set `account_id` to your management account ID. All other values can stay as-is unless you need a different bucket name or role name.

### 3. Initialise

```bash
cd finomics-infra-tf-code/finomix-tf-config

terraform init
```

### 4. Plan

```bash
terraform plan -out=tfplan
```

Review the plan — expected resources: 1 S3 bucket, 1 public-access block, 1 versioning config, 1 bucket policy, 3 S3 folder objects, 1 IAM role, 1 IAM role policy, 1 null_resource.

### 5. Apply

```bash
terraform apply tfplan
```

### 6. Share the role ARN with Finomics

```bash
terraform output role_arn
# arn:aws:iam::<your-account-id>:role/finomics-access-role
```

Provide this ARN to Finomics to complete the cross-account access setup.

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `chdir: no such file or directory` | `TF_DIR` in pipeline points to wrong path | Ensure `TF_DIR` is `finomics-infra-tf-code/finomix-tf-config` (no `AWS/` prefix) |
| `NoSuchBucket` on `terraform init` | State bucket does not exist | Create `finomics-aws-terraform-pov-new-statefile` in `us-east-1` before running init |
| `Access Denied` on S3 PutObject from child account | Bucket policy condition mismatch | Verify `org_id` in `terraform.tfvars` matches the output of `aws organizations describe-organization --query 'Organization.Id'` |
| `Access Denied` assuming the IAM role | Trust policy ARN mismatch | Confirm `trusted_account_arn` includes the exact ARN of the Finomics role: `arn:aws:iam::364582896484:role/finomics_data_pipeline_role` |
| Compute Optimizer enrollment fails | AWS CLI not installed or insufficient permissions | Remove the `null_resource` block from `main.tf` or ensure the CLI is configured with `compute-optimizer:UpdateEnrollmentStatus` permission |
| IAM changes not reflected immediately | IAM propagation delay | Wait 30–60 seconds and retry |
