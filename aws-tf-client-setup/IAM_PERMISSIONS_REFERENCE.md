# IAM Policy — Permission Reference

Read-only policy for viewing resource configuration, usage metrics, and cost optimization recommendations across 44 AWS services. Scoped to prevent access to confidential data — only resource metadata, billing, and recommendations.

---

## Statement 1 — Cost Explorer & Organizations

### Cost Explorer (`ce`)

| Action                                    | Description                                                |
| ----------------------------------------- | ---------------------------------------------------------- |
| `GetCostAndUsage`                       | Retrieve cost and usage data for a specified time period   |
| `GetCostForecast`                       | Get a forecast of future costs based on historical data    |
| `GetDimensionValues`                    | List available filter values (e.g. service names, regions) |
| `GetTags`                               | List cost allocation tag keys and values                   |
| `ListCostAllocationTags`                | List all cost allocation tags and their status             |
| `GetRightsizingRecommendation`          | Get EC2 rightsizing recommendations to reduce spend        |
| `GetSavingsPlansUtilizationDetails`     | View per-resource Savings Plans utilization                |
| `GetSavingsPlansPurchaseRecommendation` | Get recommendations for purchasing Savings Plans           |
| `GetSavingsPlansCoverage`               | See how much usage is covered by Savings Plans             |
| `GetSavingsPlansUtilization`            | View overall Savings Plans utilization rate                |
| `GetReservationUtilization`             | View Reserved Instance utilization rate                    |
| `GetReservationCoverage`                | See how much usage is covered by Reserved Instances        |
| `GetReservationPurchaseRecommendation`  | Get recommendations for purchasing Reserved Instances      |

### Cost Optimization Hub (`cost-optimization-hub`)

| Action                          | Description                                        |
| ------------------------------- | -------------------------------------------------- |
| `ListRecommendations`         | List all cost optimization recommendations         |
| `ListRecommendationSummaries` | Get summarized recommendation counts and savings   |
| `GetPreferences`              | Retrieve Cost Optimization Hub preference settings |
| `GetRecommendation`           | Get details of a specific recommendation           |

### Organizations (`organizations`)

| Action                    | Description                                 |
| ------------------------- | ------------------------------------------- |
| `DescribeOrganization`  | Get details about the AWS Organization      |
| `DescribeAccount`       | Get details about a specific member account |
| `ListAccounts`          | List all accounts in the organization       |
| `ListParents`           | Get the parent OU or root for an account/OU |
| `ListAccountsForParent` | List accounts under a specific OU or root   |
| `ListRoots`             | List the root(s) of the organization        |

---

## Statement 2 — Resource Details & Metrics

### Utility

#### STS (`sts`)

| Action                | Description                                            |
| --------------------- | ------------------------------------------------------ |
| `GetCallerIdentity` | Get the account ID and IAM user/role ARN of the caller |

#### Resource Groups Tagging (`tag`)

| Action           | Description                                     |
| ---------------- | ----------------------------------------------- |
| `GetResources` | List resources across services filtered by tags |
| `GetTagKeys`   | List all tag keys in use across the account     |
| `GetTagValues` | List all values for a specific tag key          |

---

### Observability

#### CloudWatch (`cloudwatch`)

| Action                  | Description                                       |
| ----------------------- | ------------------------------------------------- |
| `GetMetricData`       | Retrieve metric data points in batch              |
| `GetMetricStatistics` | Get statistics (avg, sum, max, etc.) for a metric |
| `ListMetrics`         | List all available metrics across services        |
| `DescribeAlarms`      | List CloudWatch alarms and their states           |
| `ListDashboards`      | List CloudWatch dashboards                        |

#### CloudWatch Logs (`logs`)

| Action                    | Description                                        |
| ------------------------- | -------------------------------------------------- |
| `DescribeLogGroups`     | List log groups and their retention settings       |
| `DescribeLogStreams`    | List log streams within a log group                |
| `DescribeMetricFilters` | List metric filters that extract metrics from logs |

---

### Recommendations

#### Compute Optimizer (`compute-optimizer`)

| Action                                   | Description                                           |
| ---------------------------------------- | ----------------------------------------------------- |
| `GetEnrollmentStatus`                  | Check if the account is enrolled in Compute Optimizer |
| `GetEnrollmentStatusesForOrganization` | Check enrollment across all org accounts              |
| `GetRecommendationSummaries`           | Get aggregated recommendation counts by resource type |
| `GetRecommendationPreferences`         | View preference settings (e.g. enhanced metrics)      |
| `GetEC2InstanceRecommendations`        | Get rightsizing recommendations for EC2 instances     |
| `GetAutoScalingGroupRecommendations`   | Get rightsizing recommendations for ASGs              |
| `GetECSServiceRecommendations`         | Get recommendations for ECS Fargate services          |
| `GetEBSVolumeRecommendations`          | Get recommendations for EBS volume types/sizes        |
| `GetLambdaFunctionRecommendations`     | Get memory configuration recommendations for Lambda   |
| `GetRDSDatabaseRecommendations`        | Get rightsizing recommendations for RDS instances     |
| `GetLicenseRecommendations`            | Get OS/license optimization recommendations           |
| `GetIdleRecommendations`               | Identify idle or underutilized resources              |

#### Trusted Advisor (`support`)

| Action                                   | Description                               |
| ---------------------------------------- | ----------------------------------------- |
| `DescribeTrustedAdvisorChecks`         | List all available Trusted Advisor checks |
| `DescribeTrustedAdvisorCheckResult`    | Get results for a specific check          |
| `DescribeTrustedAdvisorCheckSummaries` | Get summary status for multiple checks    |

---

### Compute

#### EC2 (`ec2`)

| Action                            | Description                                         |
| --------------------------------- | --------------------------------------------------- |
| `DescribeInstances`             | List instances with type, state, tags, networking   |
| `DescribeTags`                  | List tags across all EC2 resource types             |
| `DescribeVolumes`               | List EBS volumes with size, type, IOPS, attachments |
| `DescribeSnapshots`             | List EBS snapshots with size and creation date      |
| `DescribeVpcs`                  | List VPCs and their CIDR blocks                     |
| `DescribeSubnets`               | List subnets with AZ and available IPs              |
| `DescribeSecurityGroups`        | List security groups and their rules                |
| `DescribeNetworkInterfaces`     | List ENIs and their attachments                     |
| `DescribeRouteTables`           | List route tables and routes                        |
| `DescribeInternetGateways`      | List internet gateways and VPC attachments          |
| `DescribeNatGateways`           | List NAT gateways with state and subnet             |
| `DescribeAddresses`             | List Elastic IPs and their associations             |
| `DescribeKeyPairs`              | List SSH key pairs                                  |
| `DescribeAvailabilityZones`     | List AZs in the region                              |
| `DescribeRegions`               | List all AWS regions                                |
| `DescribePlacementGroups`       | List placement groups                               |
| `DescribeVpcPeeringConnections` | List VPC peering connections                        |
| `DescribeVpcEndpoints`          | List VPC endpoints (gateway and interface)          |
| `DescribeReservedInstances`     | List purchased Reserved Instances                   |
| `DescribeImages`                | List AMIs available to the account                  |
| `DescribeInstanceTypes`         | List instance type specs (vCPU, memory, etc.)       |

#### Auto Scaling (`autoscaling`)

| Action                        | Description                                   |
| ----------------------------- | --------------------------------------------- |
| `DescribeAutoScalingGroups` | List ASGs with instance counts, launch config |
| `DescribePolicies`          | List scaling policies attached to ASGs        |

#### Lambda (`lambda`)

| Action                       | Description                                             |
| ---------------------------- | ------------------------------------------------------- |
| `ListFunctions`            | List all Lambda functions                               |
| `GetFunctionConfiguration` | Get runtime, memory, timeout, environment settings ⚠️ |
| `ListEventSourceMappings`  | List event source triggers (SQS, Kinesis, etc.)         |
| `ListAliases`              | List function aliases                                   |
| `ListVersionsByFunction`   | List published versions of a function                   |
| `ListTags`                 | List tags on a function                                 |

#### Lightsail (`lightsail`)

| Action                     | Description                                       |
| -------------------------- | ------------------------------------------------- |
| `GetInstances`           | List Lightsail instances with plan/bundle details |
| `GetRelationalDatabases` | List Lightsail managed databases                  |
| `GetLoadBalancers`       | List Lightsail load balancers                     |
| `GetContainerServices`   | List Lightsail container services                 |
| `GetDisks`               | List Lightsail block storage disks                |

#### Batch (`batch`)

| Action                          | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| `DescribeComputeEnvironments` | List compute environments with instance types    |
| `DescribeJobQueues`           | List job queues and their priority/state         |
| `DescribeJobDefinitions`      | Get job definitions with vCPU/memory config ⚠️ |
| `ListJobs`                    | List jobs in a queue                             |
| `ListTagsForResource`         | List tags on Batch resources                     |

#### App Runner (`apprunner`)

| Action                  | Description                                    |
| ----------------------- | ---------------------------------------------- |
| `ListServices`        | List App Runner services                       |
| `DescribeService`     | Get service config (CPU, memory, scaling) ⚠️ |
| `ListTagsForResource` | List tags on App Runner services               |

---

### Containers

#### ECS (`ecs`)

| Action                         | Description                                         |
| ------------------------------ | --------------------------------------------------- |
| `ListClusters`               | List ECS clusters                                   |
| `DescribeClusters`           | Get cluster capacity, service count, status         |
| `ListServices`               | List services in a cluster                          |
| `DescribeServices`           | Get service config (task count, LB, deployment)     |
| `ListTasks`                  | List running tasks                                  |
| `DescribeTasks`              | Get task details (container status, resource usage) |
| `ListTaskDefinitions`        | List task definition families and revisions         |
| `DescribeTaskDefinition`     | Get CPU, memory, container definitions ⚠️         |
| `ListContainerInstances`     | List EC2 instances in an ECS cluster                |
| `DescribeContainerInstances` | Get instance capacity and registered resources      |

#### ECR (`ecr`)

| Action                   | Description                         |
| ------------------------ | ----------------------------------- |
| `DescribeRepositories` | List container image repositories   |
| `DescribeImages`       | List images with size and push date |
| `GetRepositoryPolicy`  | Get the repository access policy    |
| `ListImages`           | List image tags in a repository     |
| `ListTagsForResource`  | List tags on repositories           |

#### EKS (`eks`)

| Action                  | Description                                      |
| ----------------------- | ------------------------------------------------ |
| `ListClusters`        | List EKS clusters                                |
| `DescribeCluster`     | Get cluster version, endpoint, networking config |
| `ListNodegroups`      | List managed node groups                         |
| `DescribeNodegroup`   | Get node group instance types, scaling config    |
| `ListAddons`          | List installed cluster add-ons                   |
| `DescribeAddon`       | Get add-on version and config                    |
| `ListFargateProfiles` | List Fargate profiles for serverless pods        |

---

### Databases

#### RDS (`rds`) — also covers Aurora & Neptune

| Action                         | Description                                   |
| ------------------------------ | --------------------------------------------- |
| `DescribeDBInstances`        | List DB instances with engine, class, storage |
| `DescribeDBClusters`         | List Aurora/Neptune clusters with config      |
| `DescribeDBClusterEndpoints` | List cluster reader/writer endpoints          |
| `DescribeDBSnapshots`        | List DB snapshots with size                   |
| `DescribeDBSubnetGroups`     | List subnet groups used by DB instances       |
| `DescribeDBParameterGroups`  | List parameter groups and their settings      |
| `ListTagsForResource`        | List tags on RDS resources                    |

#### DynamoDB (`dynamodb`)

| Action                  | Description                                     |
| ----------------------- | ----------------------------------------------- |
| `ListTables`          | List DynamoDB tables                            |
| `DescribeTable`       | Get table config (capacity mode, RCU/WCU, size) |
| `ListGlobalTables`    | List global (multi-region) tables               |
| `DescribeGlobalTable` | Get global table replication config             |
| `DescribeTimeToLive`  | Check if TTL is enabled on a table              |
| `ListBackups`         | List on-demand backups                          |
| `ListTagsOfResource`  | List tags on a table                            |

#### ElastiCache (`elasticache`)

| Action                           | Description                                |
| -------------------------------- | ------------------------------------------ |
| `DescribeCacheClusters`        | List cache clusters with node type, engine |
| `DescribeReplicationGroups`    | List Redis replication groups              |
| `DescribeCacheSubnetGroups`    | List subnet groups for cache clusters      |
| `DescribeCacheParameterGroups` | List parameter groups                      |
| `ListTagsForResource`          | List tags on cache resources               |

#### MemoryDB (`memorydb`)

| Action                      | Description                                   |
| --------------------------- | --------------------------------------------- |
| `DescribeClusters`        | List MemoryDB clusters with node type, shards |
| `DescribeSubnetGroups`    | List subnet groups                            |
| `DescribeParameterGroups` | List parameter groups                         |
| `ListTags`                | List tags on MemoryDB resources               |

#### DAX (`dax`)

| Action                      | Description                             |
| --------------------------- | --------------------------------------- |
| `DescribeClusters`        | List DAX clusters with node type, count |
| `DescribeSubnetGroups`    | List subnet groups                      |
| `DescribeParameterGroups` | List parameter groups                   |
| `ListTags`                | List tags on DAX resources              |

#### Redshift (`redshift`)

| Action                               | Description                                  |
| ------------------------------------ | -------------------------------------------- |
| `DescribeClusters`                 | List clusters with node type, count, storage |
| `DescribeNodeConfigurationOptions` | List available node configs for resize       |
| `DescribeReservedNodes`            | List purchased reserved nodes                |
| `DescribeClusterSnapshots`         | List cluster snapshots                       |
| `DescribeClusterSubnetGroups`      | List subnet groups                           |
| `DescribeClusterParameterGroups`   | List parameter groups                        |
| `DescribeTags`                     | List tags on Redshift resources              |

#### Timestream (`timestream`)

| Action                  | Description                           |
| ----------------------- | ------------------------------------- |
| `ListDatabases`       | List Timestream databases             |
| `DescribeDatabase`    | Get database retention settings       |
| `ListTables`          | List tables in a database             |
| `DescribeTable`       | Get table schema and retention config |
| `ListTagsForResource` | List tags on Timestream resources     |

#### OpenSearch / Elasticsearch (`es`)

| Action              | Description                                         |
| ------------------- | --------------------------------------------------- |
| `ListDomainNames` | List OpenSearch domains                             |
| `DescribeDomains` | Get config for multiple domains                     |
| `DescribeDomain`  | Get a single domain's instance type, count, storage |
| `ListTags`        | List tags on a domain                               |

---

### Storage

#### S3 (`s3`) — bucket metadata (all buckets)

| Action                          | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| `ListAllMyBuckets`            | List all S3 buckets in the account               |
| `GetBucketLocation`           | Get the region a bucket is in                    |
| `GetEncryptionConfiguration`  | Get bucket default encryption settings           |
| `GetBucketVersioning`         | Check if versioning is enabled                   |
| `GetBucketTagging`            | Get bucket tags                                  |
| `GetBucketLogging`            | Get access logging config                        |
| `GetLifecycleConfiguration`   | Get object lifecycle transition/expiration rules |
| `GetBucketPublicAccessBlock`  | Get public access block settings                 |
| `GetBucketAcl`                | Get bucket access control list                   |
| `GetBucketPolicy`             | Get bucket resource policy                       |
| `GetBucketPolicyStatus`       | Check if bucket policy allows public access      |
| `GetBucketNotification`       | Get event notification config                    |
| `GetReplicationConfiguration` | Get cross-region replication config              |

#### Glacier (`glacier`)

| Action                    | Description                       |
| ------------------------- | --------------------------------- |
| `ListVaults`            | List Glacier vaults               |
| `DescribeVault`         | Get vault size, archive count     |
| `ListJobs`              | List retrieval and inventory jobs |
| `GetVaultNotifications` | Get vault notification config     |

#### EFS (`elasticfilesystem`)

| Action                             | Description                                  |
| ---------------------------------- | -------------------------------------------- |
| `DescribeFileSystems`            | List file systems with size, throughput mode |
| `DescribeMountTargets`           | List mount targets and their subnets         |
| `DescribeAccessPoints`           | List access points                           |
| `DescribeLifecycleConfiguration` | Get lifecycle policies (IA transitions)      |

---

### Networking & Content Delivery

#### CloudFront (`cloudfront`)

| Action                        | Description                                       |
| ----------------------------- | ------------------------------------------------- |
| `ListDistributions`         | List CDN distributions                            |
| `GetDistribution`           | Get distribution config (origins, cache, pricing) |
| `ListFunctions`             | List CloudFront Functions                         |
| `ListCachePolicies`         | List cache policies                               |
| `ListOriginRequestPolicies` | List origin request policies                      |
| `ListTagsForResource`       | List tags on distributions                        |

#### Elastic Load Balancing (`elasticloadbalancing`)

| Action                    | Description                                |
| ------------------------- | ------------------------------------------ |
| `DescribeLoadBalancers` | List ALBs, NLBs, and CLBs with config      |
| `DescribeTargetGroups`  | List target groups and health check config |
| `DescribeListeners`     | List listeners (port, protocol, rules)     |
| `DescribeRules`         | List routing rules on a listener           |
| `DescribeTags`          | List tags on LB resources                  |
| `DescribeTargetHealth`  | Get health status of targets               |

---

### Streaming & Messaging

#### Kinesis Data Streams (`kinesis`)

| Action                    | Description                                      |
| ------------------------- | ------------------------------------------------ |
| `ListStreams`           | List Kinesis data streams                        |
| `DescribeStream`        | Get shard count, retention, encryption config    |
| `DescribeStreamSummary` | Get stream summary (lighter than DescribeStream) |
| `ListTagsForStream`     | List tags on a stream                            |

#### Kinesis Data Firehose (`firehose`)

| Action                        | Description                                    |
| ----------------------------- | ---------------------------------------------- |
| `ListDeliveryStreams`       | List Firehose delivery streams                 |
| `DescribeDeliveryStream`    | Get destination, buffering, compression config |
| `ListTagsForDeliveryStream` | List tags on a delivery stream                 |

#### MSK — Managed Kafka (`kafka`)

| Action                  | Description                                  |
| ----------------------- | -------------------------------------------- |
| `ListClusters`        | List MSK clusters (provisioned)              |
| `ListClustersV2`      | List MSK clusters (provisioned + serverless) |
| `DescribeCluster`     | Get broker type, count, storage config       |
| `DescribeClusterV2`   | Get cluster details (v2 API)                 |
| `ListConfigurations`  | List custom MSK configurations               |
| `ListTagsForResource` | List tags on MSK resources                   |

#### SNS (`sns`)

| Action                  | Description                                    |
| ----------------------- | ---------------------------------------------- |
| `ListTopics`          | List SNS topics                                |
| `GetTopicAttributes`  | Get topic config (delivery policy, encryption) |
| `ListTagsForResource` | List tags on topics                            |

#### SQS (`sqs`)

| Action                 | Description                                           |
| ---------------------- | ----------------------------------------------------- |
| `ListQueues`         | List SQS queues                                       |
| `GetQueueAttributes` | Get queue config (visibility timeout, retention, DLQ) |
| `ListQueueTags`      | List tags on a queue                                  |

#### Amazon MQ (`mq`)

| Action             | Description                                       |
| ------------------ | ------------------------------------------------- |
| `ListBrokers`    | List MQ brokers (ActiveMQ / RabbitMQ)             |
| `DescribeBroker` | Get broker instance type, engine, deployment mode |
| `ListTags`       | List tags on brokers                              |

---

### ML & AI

#### Bedrock (`bedrock`)

| Action                                     | Description                                  |
| ------------------------------------------ | -------------------------------------------- |
| `GetFoundationModel`                     | Get details of a foundation model            |
| `ListFoundationModels`                   | List available foundation models             |
| `ListCustomModels`                       | List fine-tuned custom models                |
| `GetCustomModel`                         | Get custom model config                      |
| `GetProvisionedModelThroughput`          | Get provisioned throughput details           |
| `ListProvisionedModelThroughputs`        | List all provisioned throughput reservations |
| `ListTagsForResource`                    | List tags on Bedrock resources               |
| `GetModelInvocationLoggingConfiguration` | Get model invocation logging settings        |

#### SageMaker (`sagemaker`)

| Action                       | Description                                          |
| ---------------------------- | ---------------------------------------------------- |
| `ListEndpoints`            | List inference endpoints                             |
| `DescribeEndpoint`         | Get endpoint instance type, count, variant config    |
| `DescribeEndpointConfig`   | Get endpoint configuration (instance types, weights) |
| `ListNotebookInstances`    | List notebook instances                              |
| `DescribeNotebookInstance` | Get notebook instance type, volume size              |
| `ListTrainingJobs`         | List training jobs                                   |
| `DescribeTrainingJob`      | Get training job instance type, duration, status     |
| `ListTags`                 | List tags on SageMaker resources                     |

---

### Data Processing & ETL

#### Glue (`glue`)

| Action           | Description                             |
| ---------------- | --------------------------------------- |
| `GetJobs`      | List Glue ETL jobs                      |
| `GetJob`       | Get job config (worker type, DPU count) |
| `GetDatabases` | List Glue Data Catalog databases        |
| `GetTables`    | List tables in a database               |
| `GetCrawlers`  | List Glue crawlers                      |
| `GetCrawler`   | Get crawler config and schedule         |
| `GetTriggers`  | List job triggers                       |

#### EMR (`elasticmapreduce`)

| Action                 | Description                                |
| ---------------------- | ------------------------------------------ |
| `ListClusters`       | List EMR clusters                          |
| `DescribeCluster`    | Get cluster instance types, status, config |
| `ListInstances`      | List EC2 instances in a cluster            |
| `ListInstanceGroups` | List instance groups (master, core, task)  |

---

### Infrastructure & Orchestration

#### CloudFormation (`cloudformation`)

| Action                     | Description                           |
| -------------------------- | ------------------------------------- |
| `ListStacks`             | List all stacks and their status      |
| `DescribeStacks`         | Get stack parameters, outputs, status |
| `ListStackResources`     | List resources in a stack             |
| `DescribeStackResources` | Get resource details within a stack   |
| `DescribeStackEvents`    | Get stack event history               |

#### Step Functions (`states`)

| Action                   | Description                              |
| ------------------------ | ---------------------------------------- |
| `ListStateMachines`    | List state machines                      |
| `DescribeStateMachine` | Get state machine definition, role, type |
| `ListExecutions`       | List executions of a state machine       |
| `ListActivities`       | List Step Functions activities           |
| `ListTagsForResource`  | List tags on state machines              |

#### Systems Manager (`ssm`)

| Action                          | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| `DescribeInstanceInformation` | List managed instances with OS, agent status     |
| `DescribeParameters`          | List SSM parameters (names only, not values)     |
| `ListDocuments`               | List SSM documents (runbooks, commands)          |
| `GetInventory`                | Get software and config inventory from instances |
| `DescribePatchBaselines`      | List patch baselines                             |
| `ListAssociations`            | List State Manager associations                  |

---

## Statement 3 — S3 Bucket Object Read (scoped)

#### S3 (`s3`) — object access (single bucket)

| Action         | Description                                    |
| -------------- | ---------------------------------------------- |
| `ListBucket` | List objects within the specified bucket       |
| `GetObject`  | Read object contents from the specified bucket |

**Resource:** `arn:aws:s3:::<BUCKET_NAME>` and `arn:aws:s3:::<BUCKET_NAME>/*`

Replace `<BUCKET_NAME>` with the client's bucket name.

---

## Summary

| Category                   | Services                                 | Actions       |
| -------------------------- | ---------------------------------------- | ------------- |
| Cost & Org                 | ce, cost-optimization-hub, organizations | 23            |
| Resource Details & Metrics | 41 services                              | 232           |
| S3 Object Read (scoped)    | s3                                       | 2             |
| **Total**            | **44 services**                    | **257** |
