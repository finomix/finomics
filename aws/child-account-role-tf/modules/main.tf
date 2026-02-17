resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_role_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "finomics_access_policy" {
  name = "${var.role_name}-policy"

  policy = jsonencode({
  Version = "2012-10-17"
  Statement = [

    # -------------------------
    # Cost & Billing
    # -------------------------
    {
      Sid    = "CostExplorer"
      Effect = "Allow"
      Action = [
        "ce:GetCostAndUsage",
        "ce:GetReservationUtilization"
      ]
      Resource = "*"
    },

    # -------------------------
    # API Gateway
    # -------------------------
    {
      Sid    = "ApiGatewayRead"
      Effect = "Allow"
      Action = [
        "apigateway:GET"
      ]
      Resource = "*"
    },

    # -------------------------
    # Auto Scaling
    # -------------------------
    {
      Sid    = "ApplicationAutoScalingRead"
      Effect = "Allow"
      Action = [
        "application-autoscaling:DescribeScalableTargets"
      ]
      Resource = "*"
    },

    # -------------------------
    # AWS Backup
    # -------------------------
    {
      Sid    = "BackupRead"
      Effect = "Allow"
      Action = [
        "backup:DescribeBackupVault",
        "backup:DescribeRecoveryPoint",
        "backup:ListBackupPlans",
        "backup:ListRecoveryPointsByBackupVault",
        "backup:ListBackupVaults"
      ]
      Resource = "*"
    },

    # -------------------------
    # CloudFormation
    # -------------------------
    {
      Sid    = "CloudFormationRead"
      Effect = "Allow"
      Action = [
        "cloudformation:DescribeStacks",
        "cloudformation:GetStackPolicy",
        "cloudformation:GetTemplate",
        "cloudformation:ListStacks"
      ]
      Resource = "*"
    },

    # -------------------------
    # CloudFront
    # -------------------------
    {
      Sid    = "CloudFrontRead"
      Effect = "Allow"
      Action = [
        "cloudfront:GetDistribution",
        "cloudfront:GetDistributionConfig",
        "cloudfront:ListDistributions"
      ]
      Resource = "*"
    },

    # -------------------------
    # CloudTrail
    # -------------------------
    {
      Sid    = "CloudTrailRead"
      Effect = "Allow"
      Action = [
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:LookupEvents"
      ]
      Resource = "*"
    },

    # -------------------------
    # CloudWatch
    # -------------------------
    {
      Sid    = "CloudWatchRead"
      Effect = "Allow"
      Action = [
        "cloudwatch:DescribeAlarms",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "cloudwatch:ListDashboards"
      ]
      Resource = "*"
    },

    # -------------------------
    # CI/CD (CodeBuild, CodePipeline)
    # -------------------------
    {
      Sid    = "CodeBuildRead"
      Effect = "Allow"
      Action = [
        "codebuild:BatchGetBuilds",
        "codebuild:BatchGetProjects",
        "codebuild:ListBuilds",
        "codebuild:ListProjects"
      ]
      Resource = "*"
    },
    {
      Sid    = "CodePipelineRead"
      Effect = "Allow"
      Action = [
        "codepipeline:GetPipeline",
        "codepipeline:GetPipelineState",
        "codepipeline:ListPipelines"
      ]
      Resource = "*"
    },

    # -------------------------
    # AWS Config
    # -------------------------
    {
      Sid    = "ConfigRead"
      Effect = "Allow"
      Action = [
        "config:DescribeConfigurationRecorderStatus",
        "config:DescribeConfigurationRecorders",
        "config:DescribeDeliveryChannels",
        "config:GetComplianceSummaryByConfigRule"
      ]
      Resource = "*"
    },

    # -------------------------
    # DynamoDB
    # -------------------------
    {
      Sid    = "DynamoDBRead"
      Effect = "Allow"
      Action = [
        "dynamodb:DescribeTable",
        "dynamodb:DescribeTimeToLive",
        "dynamodb:ListTables"
      ]
      Resource = "*"
    },

    # -------------------------
    # EC2 & Networking
    # -------------------------
    {
      Sid    = "EC2Read"
      Effect = "Allow"
      Action = [
        "ec2:DescribeCustomerGateways",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeInstances",
        "ec2:DescribeNatGateways",
        "ec2:DescribeReservedInstances",
        "ec2:DescribeReservedInstancesOfferings",
        "ec2:DescribeSpotInstanceRequests",
        "ec2:DescribeSpotPriceHistory",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeVolumes",
        "ec2:DescribeVpcEndpointServices",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeVpnConnections",
        "ec2:DescribeVpnGateways"
      ]
      Resource = "*"
    },

    # -------------------------
    # ECR
    # -------------------------
    {
      Sid    = "ECRRead"
      Effect = "Allow"
      Action = [
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetRepositoryPolicy"
      ]
      Resource = "*"
    },

    # -------------------------
    # ECS
    # -------------------------
    {
      Sid    = "ECSRead"
      Effect = "Allow"
      Action = [
        "ecs:DescribeClusters",
        "ecs:DescribeServices",
        "ecs:DescribeTasks",
        "ecs:ListClusters",
        "ecs:ListServices",
        "ecs:ListTasks"
      ]
      Resource = "*"
    },

    # -------------------------
    # ELB
    # -------------------------
    {
      Sid    = "ELBRead"
      Effect = "Allow"
      Action = [
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetHealth"
      ]
      Resource = "*"
    },

    # -------------------------
    # OpenSearch (ES)
    # -------------------------
    {
      Sid    = "OpenSearchRead"
      Effect = "Allow"
      Action = [
        "es:DescribeDomain",
        "es:DescribeDomainConfig",
        "es:ListDomainNames"
      ]
      Resource = "*"
    },

    # -------------------------
    # EventBridge
    # -------------------------
    {
      Sid    = "EventBridgeRead"
      Effect = "Allow"
      Action = [
        "events:DescribeEventBus",
        "events:DescribeRule",
        "events:ListEventBuses",
        "events:ListRules"
      ]
      Resource = "*"
    },

    # -------------------------
    # GuardDuty
    # -------------------------
    {
      Sid    = "GuardDutyRead"
      Effect = "Allow"
      Action = [
        "guardduty:GetDetector",
        "guardduty:ListDetectors",
        "guardduty:ListFindings"
      ]
      Resource = "*"
    },

    # -------------------------
    # KMS
    # -------------------------
    {
      Sid    = "KMSRead"
      Effect = "Allow"
      Action = [
        "kms:DescribeKey",
        "kms:ListAliases",
        "kms:ListKeys"
      ]
      Resource = "*"
    },

    # -------------------------
    # Lambda
    # -------------------------
    {
      Sid    = "LambdaRead"
      Effect = "Allow"
      Action = [
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration",
        "lambda:ListFunctions",
        "lambda:ListVersionsByFunction"
      ]
      Resource = "*"
    },

    # -------------------------
    # CloudWatch Logs
    # -------------------------
    {
      Sid    = "LogsRead"
      Effect = "Allow"
      Action = [
        "logs:DescribeLogGroups"
      ]
      Resource = "*"
    },

    # -------------------------
    # MediaPackage
    # -------------------------
    {
      Sid    = "MediaPackageRead"
      Effect = "Allow"
      Action = [
        "mediapackage:DescribeChannel",
        "mediapackage:ListChannels"
      ]
      Resource = "*"
    },

    # -------------------------
    # RDS
    # -------------------------
    {
      Sid    = "RDSRead"
      Effect = "Allow"
      Action = [
        "rds:DescribeDBClusterEndpoints",
        "rds:DescribeDBClusters",
        "rds:DescribeDBInstances",
        "rds:DescribeDBSnapshots"
      ]
      Resource = "*"
    },

    # -------------------------
    # Route53
    # -------------------------
    {
      Sid    = "Route53Read"
      Effect = "Allow"
      Action = [
        "route53:GetHealthCheck",
        "route53:GetHostedZone",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ]
      Resource = "*"
    },

    # -------------------------
    # S3
    # -------------------------
    {
      Sid    = "S3Read"
      Effect = "Allow"
      Action = [
        "s3:GetBucketLocation",
        "s3:GetBucketMetrics",
        "s3:ListAllMyBuckets",
        "s3:ListBucket"
      ]
      Resource = "*"
    },

    # -------------------------
    # Secrets Manager
    # -------------------------
    {
      Sid    = "SecretsManagerRead"
      Effect = "Allow"
      Action = [
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecrets"
      ]
      Resource = "*"
    },

    # -------------------------
    # Service Discovery
    # -------------------------
    {
      Sid    = "ServiceDiscoveryRead"
      Effect = "Allow"
      Action = [
        "servicediscovery:GetNamespace",
        "servicediscovery:ListNamespaces",
        "servicediscovery:ListServices"
      ]
      Resource = "*"
    },

    # -------------------------
    # SNS
    # -------------------------
    {
      Sid    = "SNSRead"
      Effect = "Allow"
      Action = [
        "sns:GetTopicAttributes",
        "sns:ListSubscriptions",
        "sns:ListTopics"
      ]
      Resource = "*"
    },

    # -------------------------
    # SQS
    # -------------------------
    {
      Sid    = "SQSRead"
      Effect = "Allow"
      Action = [
        "sqs:GetQueueAttributes",
        "sqs:ListQueues"
      ]
      Resource = "*"
    }
  ]
})

}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.finomics_access_policy.arn
}
