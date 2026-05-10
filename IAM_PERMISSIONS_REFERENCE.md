# AWS IAM Permissions Reference

This document lists all IAM permissions used in the Finomics Terraform infrastructure.

## IAM Role Permissions (Finomics Access Role)

| Permission | Description |
|------------|-------------|
| **Cost Explorer & Cost Optimization** | |
| `ce:GetCostAndUsage` | Retrieve cost and usage metrics for the account |
| `ce:GetCostForecast` | Get forecasted cost predictions |
| `ce:GetDimensionValues` | Retrieve dimension values for filtering cost data |
| `ce:GetTags` | Get tag keys and values for cost allocation |
| `ce:ListCostAllocationTags` | List all cost allocation tags |
| `ce:GetRightsizingRecommendation` | Get EC2 rightsizing recommendations |
| `ce:GetSavingsPlansUtilizationDetails` | Retrieve Savings Plans utilization and coverage details |
| `ce:GetReservationUtilization` | Get Reserved Instance utilization data |
| `cost-optimization-hub:ListRecommendations` | List cost optimization recommendations |
| `cost-optimization-hub:ListRecommendationSummaries` | Get summary of cost optimization recommendations |
| `cost-optimization-hub:GetPreferences` | Retrieve cost optimization hub preferences |
| `cost-optimization-hub:GetRecommendation` | Get detailed cost optimization recommendation |
| **Organizations** | |
| `organizations:DescribeOrganization` | Get details about the AWS Organization |
| `organizations:ListAccounts` | List all accounts in the organization |
| `organizations:ListParents` | List parent organizational units |
| `organizations:ListAccountsForParent` | List accounts under a specific organizational unit |
| **EC2** | |
| `ec2:DescribeInstances` | List and describe EC2 instances |
| `ec2:DescribeRegions` | List all AWS regions |
| `ec2:DescribeVolumes` | Describe EBS volumes |
| **RDS** | |
| `rds:DescribeDBInstances` | List and describe RDS database instances |
| **Auto Scaling** | |
| `autoscaling:DescribeAutoScalingGroups` | Describe Auto Scaling groups |
| `autoscaling:DescribePolicies` | Describe Auto Scaling policies |
| **CloudWatch** | |
| `cloudwatch:GetMetricStatistics` | Retrieve CloudWatch metric statistics |
| **SSM Parameter Store** | |
| `ssm:GetParameters` | Retrieve parameters from Systems Manager Parameter Store |
| **Compute Optimizer** | |
| `compute-optimizer:GetEnrollmentStatus` | Check if Compute Optimizer is enrolled |
| `compute-optimizer:GetEC2InstanceRecommendations` | Get EC2 instance optimization recommendations |
| `compute-optimizer:GetECSServiceRecommendations` | Get ECS service optimization recommendations |
| `compute-optimizer:GetEBSVolumeRecommendations` | Get EBS volume optimization recommendations |
| **Trusted Advisor** | |
| `trustedadvisor:GetCheckResult` | Get results from Trusted Advisor checks |
| `trustedadvisor:DescribeCheckItems` | Describe Trusted Advisor check items |

---

## Finomics Bronze Read-Only Permissions (FinomicsBronzeReadOnly)

All actions below apply to `Resource: "*"`.

| Service | Actions |
|---------|---------|
| **STS** | `sts:GetCallerIdentity` |
| **Tag** | `tag:GetResources`, `tag:GetTagKeys`, `tag:GetTagValues` |
| **Bedrock** | `bedrock:GetFoundationModel`, `bedrock:ListFoundationModels`, `bedrock:ListCustomModels`, `bedrock:GetCustomModel`, `bedrock:GetProvisionedModelThroughput`, `bedrock:ListProvisionedModelThroughputs`, `bedrock:ListTagsForResource`, `bedrock:GetModelInvocationLoggingConfiguration` |
| **CloudWatch** | `cloudwatch:GetMetricData`, `cloudwatch:GetMetricStatistics`, `cloudwatch:ListMetrics`, `cloudwatch:DescribeAlarms`, `cloudwatch:ListDashboards` |
| **CloudWatch Logs** | `logs:DescribeLogGroups`, `logs:DescribeLogStreams`, `logs:DescribeMetricFilters` |
| **EC2** | `ec2:DescribeInstances`, `ec2:DescribeTags`, `ec2:DescribeVolumes`, `ec2:DescribeSnapshots`, `ec2:DescribeVpcs`, `ec2:DescribeSubnets`, `ec2:DescribeSecurityGroups`, `ec2:DescribeNetworkInterfaces`, `ec2:DescribeRouteTables`, `ec2:DescribeInternetGateways`, `ec2:DescribeNatGateways`, `ec2:DescribeAddresses`, `ec2:DescribeKeyPairs`, `ec2:DescribeAvailabilityZones`, `ec2:DescribeRegions`, `ec2:DescribePlacementGroups`, `ec2:DescribeVpcPeeringConnections`, `ec2:DescribeVpcEndpoints`, `ec2:DescribeReservedInstances`, `ec2:DescribeImages`, `ec2:DescribeInstanceTypes` |
| **ACM** | `acm:ListCertificates`, `acm:DescribeCertificate` |
| **API Gateway** | `apigateway:GET` |
| **CloudFormation** | `cloudformation:ListStacks`, `cloudformation:DescribeStacks`, `cloudformation:ListStackResources`, `cloudformation:DescribeStackResources`, `cloudformation:DescribeStackEvents`, `cloudformation:GetTemplate` |
| **CloudFront** | `cloudfront:ListDistributions`, `cloudfront:GetDistribution`, `cloudfront:ListFunctions`, `cloudfront:ListCachePolicies`, `cloudfront:ListOriginRequestPolicies`, `cloudfront:ListTagsForResource` |
| **CloudTrail** | `cloudtrail:ListTrails`, `cloudtrail:GetTrail`, `cloudtrail:DescribeTrails`, `cloudtrail:GetTrailStatus`, `cloudtrail:GetEventSelectors`, `cloudtrail:ListTags` |
| **Config** | `config:DescribeConfigurationRecorders`, `config:DescribeDeliveryChannels`, `config:DescribeConfigRules`, `config:GetComplianceDetailsByConfigRule`, `config:DescribeConfigurationRecorderStatus`, `config:DescribeDeliveryChannelStatus` |
| **DeepRacer** | `deepracer:ListModels`, `deepracer:GetModel`, `deepracer:ListLeaderboards`, `deepracer:ListRaceTracks`, `deepracer:ListCars`, `deepracer:GetCar` |
| **Direct Connect** | `directconnect:DescribeConnections`, `directconnect:DescribeVirtualInterfaces`, `directconnect:DescribeDirectConnectGateways`, `directconnect:DescribeLags`, `directconnect:DescribeLocations` |
| **DynamoDB** | `dynamodb:ListTables`, `dynamodb:DescribeTable`, `dynamodb:ListGlobalTables`, `dynamodb:DescribeGlobalTable`, `dynamodb:DescribeTimeToLive`, `dynamodb:ListBackups`, `dynamodb:ListTagsOfResource` |
| **ECR** | `ecr:DescribeRepositories`, `ecr:DescribeImages`, `ecr:GetRepositoryPolicy`, `ecr:ListImages`, `ecr:ListTagsForResource` |
| **ECS** | `ecs:ListClusters`, `ecs:DescribeClusters`, `ecs:ListServices`, `ecs:DescribeServices`, `ecs:ListTasks`, `ecs:DescribeTasks`, `ecs:ListContainerInstances`, `ecs:DescribeContainerInstances` |
| **EFS** | `elasticfilesystem:DescribeFileSystems`, `elasticfilesystem:DescribeMountTargets`, `elasticfilesystem:DescribeAccessPoints`, `elasticfilesystem:DescribeLifecycleConfiguration` |
| **EKS** | `eks:ListClusters`, `eks:DescribeCluster`, `eks:ListNodegroups`, `eks:DescribeNodegroup`, `eks:ListAddons`, `eks:DescribeAddon`, `eks:ListFargateProfiles` |
| **ElastiCache** | `elasticache:DescribeCacheClusters`, `elasticache:DescribeReplicationGroups`, `elasticache:DescribeCacheSubnetGroups`, `elasticache:DescribeCacheParameterGroups`, `elasticache:ListTagsForResource` |
| **ELB** | `elasticloadbalancing:DescribeLoadBalancers`, `elasticloadbalancing:DescribeTargetGroups`, `elasticloadbalancing:DescribeListeners`, `elasticloadbalancing:DescribeRules`, `elasticloadbalancing:DescribeTags`, `elasticloadbalancing:DescribeTargetHealth` |
| **Elasticsearch / OpenSearch** | `es:ListDomainNames`, `es:DescribeElasticsearchDomains`, `opensearch:ListDomainNames`, `opensearch:DescribeDomains`, `opensearch:DescribeDomain`, `opensearch:ListTags` |
| **Location (Geo)** | `geo:ListPlaceIndexes`, `geo:ListMaps`, `geo:ListRouteCalculators`, `geo:ListTrackers`, `geo:ListGeofenceCollections`, `geo:DescribeMap`, `geo:DescribeTracker`, `geo:DescribePlaceIndex`, `geo:DescribeRouteCalculator` |
| **Glacier** | `glacier:ListVaults`, `glacier:DescribeVault`, `glacier:ListJobs`, `glacier:GetVaultNotifications` |
| **Glue** | `glue:GetJobs`, `glue:GetJob`, `glue:GetDatabases`, `glue:GetTables`, `glue:GetCrawlers`, `glue:GetCrawler`, `glue:GetConnections`, `glue:GetDevEndpoints`, `glue:GetTriggers` |
| **GuardDuty** | `guardduty:ListDetectors`, `guardduty:GetDetector`, `guardduty:ListFindings`, `guardduty:GetFindings`, `guardduty:ListMembers`, `guardduty:GetMasterAccount` |
| **KMS** | `kms:ListKeys`, `kms:DescribeKey`, `kms:ListAliases`, `kms:GetKeyPolicy`, `kms:ListKeyPolicies`, `kms:ListResourceTags` |
| **Lambda** | `lambda:ListFunctions`, `lambda:GetFunction`, `lambda:GetFunctionConfiguration`, `lambda:ListEventSourceMappings`, `lambda:ListAliases`, `lambda:ListVersionsByFunction`, `lambda:ListTags` |
| **Payment Cryptography** | `payment-cryptography:ListKeys`, `payment-cryptography:GetKey`, `payment-cryptography:ListTagsForResource` |
| **RDS** | `rds:DescribeDBInstances`, `rds:DescribeDBClusters`, `rds:DescribeDBSnapshots`, `rds:DescribeDBSubnetGroups`, `rds:DescribeDBParameterGroups`, `rds:ListTagsForResource` |
| **Route 53** | `route53:ListHostedZones`, `route53:GetHostedZone`, `route53:ListResourceRecordSets`, `route53:ListHealthChecks`, `route53:GetHealthCheck`, `route53:ListQueryLoggingConfigs` |
| **Route 53 Domains** | `route53domains:ListDomains`, `route53domains:GetDomainDetail` |
| **S3** | `s3:ListBuckets`, `s3:GetBucketLocation`, `s3:GetBucketEncryption`, `s3:GetBucketVersioning`, `s3:GetBucketTagging`, `s3:GetBucketLogging`, `s3:GetBucketLifecycle`, `s3:GetBucketPublicAccessBlock`, `s3:GetBucketAcl`, `s3:GetBucketPolicy`, `s3:GetBucketNotification`, `s3:GetBucketReplication` |
| **Secrets Manager** | `secretsmanager:ListSecrets`, `secretsmanager:DescribeSecret` |
| **Security Hub** | `securityhub:GetFindings`, `securityhub:DescribeHub`, `securityhub:ListEnabledProductsForImport`, `securityhub:GetInsights`, `securityhub:DescribeStandards` |
| **SNS** | `sns:ListTopics`, `sns:GetTopicAttributes`, `sns:ListSubscriptionsByTopic`, `sns:ListSubscriptions`, `sns:ListTagsForResource` |
| **SQS** | `sqs:ListQueues`, `sqs:GetQueueAttributes`, `sqs:ListQueueTags` |
| **SSM** | `ssm:DescribeInstanceInformation`, `ssm:DescribeParameters`, `ssm:ListDocuments`, `ssm:GetInventory`, `ssm:DescribePatchBaselines`, `ssm:ListAssociations` |
| **Step Functions** | `states:ListStateMachines`, `states:DescribeStateMachine`, `states:ListExecutions`, `states:DescribeExecution`, `states:ListActivities`, `states:ListTagsForResource` |
| **Support** | `support:DescribeCases`, `support:DescribeTrustedAdvisorChecks`, `support:DescribeTrustedAdvisorCheckResult`, `support:DescribeTrustedAdvisorCheckSummaries`, `support:DescribeSeverityLevels` |
| **WAF** | `waf:ListWebACLs`, `waf:GetWebACL`, `waf-regional:ListWebACLs`, `waf-regional:GetWebACL`, `wafv2:ListWebACLs`, `wafv2:GetWebACL`, `wafv2:ListRuleGroups`, `wafv2:GetRuleGroup`, `wafv2:ListTagsForResource` |

---

## S3 Bucket Policy Permissions (Finomics Bucket)

| Permission | Principal | Description |
|------------|-----------|-------------|
| **Cross-Account Pipeline Access** | Pipeline Role ARN | |
| `s3:GetObject` | Pipeline Role | Read data files from the bucket |
| `s3:ListBucket` | Pipeline Role | List bucket contents for discovery |
| `s3:GetBucketVersioning` | Pipeline Role | Get bucket versioning configuration |
| `s3:GetBucketPolicyStatus` | Pipeline Role | Check if bucket has a public policy |
| `s3:GetEncryptionConfiguration` | Pipeline Role | Retrieve bucket encryption settings |

---

## IAM Role Trust Policy Permissions

| Permission | Principal | Description |
|------------|-----------|-------------|
| `sts:AssumeRole` | Trusted Account ARNs | Allow specified accounts/roles to assume the Finomics access role |

---

## Notes

- All permissions follow the **least privilege principle** where possible
- Resource-level restrictions are applied for EC2, RDS, Auto Scaling, CloudWatch, SSM, Compute Optimizer, and Trusted Advisor
- Cost Explorer and Organizations APIs require wildcard (`*`) resources as they don't support resource-level permissions
- `FinomicsBronzeReadOnly` permissions use wildcard (`*`) resource as required by those service APIs
- Cross-account access uses role assumption via `sts:AssumeRole` with explicit trust policies
