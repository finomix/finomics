# GCP Service Account Permissions Documentation

## Overview
This document outlines all permissions granted to the GCP service account at the organization level.

---

## Organization-Level Roles

### 1. **roles/billing.viewer**
- **Description**: Allows read-only visibility into billing data across the organization
- **Use Case**: View billing information, cost analysis, and financial reports
- **Scope**: Organization Level

### 2. **roles/recommender.viewer**
- **Description**: Allows viewing recommendations across the organization
- **Use Case**: Access optimization and best practice recommendations from Google Cloud
- **Scope**: Organization Level

### 3. **roles/apigee.analyticsViewer**
- **Description**: Provides read-only access to Apigee analytics
- **Use Case**: View API analytics, performance metrics, and usage data in Apigee
- **Scope**: Organization Level

### 4. **roles/apigee.readOnlyAdmin**
- **Description**: Grants read-only admin permissions for Apigee
- **Use Case**: Administrative visibility into Apigee configuration and policies without modification rights
- **Scope**: Organization Level

### 5. **roles/logging.viewer**
- **Description**: Allows viewing logs across the organization
- **Use Case**: Access Cloud Logging and audit logs for troubleshooting and monitoring
- **Scope**: Organization Level

### 6. **roles/monitoring.viewer**
- **Description**: Allows viewing monitoring metrics and dashboards
- **Use Case**: View Cloud Monitoring metrics, dashboards, and alerting policies
- **Scope**: Organization Level

### 7. **roles/browser**
- **Description**: Allows basic read-only access to Google Cloud resources
- **Use Case**: Browse resources in Cloud Console, view resource metadata
- **Scope**: Organization Level

---

## Custom Viewer Role Permissions

### Role ID: `custom_viewer_role_new`
**Title**: Custom Viewer Role
**Description**: Unified viewer role for multi-service read access at organization level
**Stage**: GA (General Availability)

#### AI Platform Permissions
- `aiplatform.endpoints.list` - List AI Platform endpoints
- `aiplatform.locations.list` - List available locations for AI Platform
- `aiplatform.models.list` - List AI Platform models
- `aiplatform.pipelineJobs.list` - List pipeline jobs
- `aiplatform.trainingPipelines.list` - List training pipelines

#### Artifact Registry Permissions
- `artifactregistry.locations.list` - List Artifact Registry locations
- `artifactregistry.repositories.get` - Get Artifact Registry repository details
- `artifactregistry.repositories.list` - List Artifact Registry repositories

#### BigTable Permissions
- `bigtable.instances.get` - Get BigTable instance details
- `bigtable.instances.list` - List BigTable instances

#### Cloud Build Permissions
- `cloudbuild.builds.get` - Get Cloud Build build details
- `cloudbuild.builds.list` - List Cloud Build builds

#### Cloud Functions Permissions
- `cloudfunctions.functions.get` - Get Cloud Functions details
- `cloudfunctions.functions.list` - List Cloud Functions

#### Cloud KMS Permissions
- `cloudkms.cryptoKeyVersions.get` - Get Cloud KMS crypto key version details
- `cloudkms.cryptoKeyVersions.list` - List Cloud KMS crypto key versions
- `cloudkms.cryptoKeys.get` - Get Cloud KMS crypto key details
- `cloudkms.cryptoKeys.list` - List Cloud KMS crypto keys
- `cloudkms.keyRings.get` - Get Cloud KMS key ring details
- `cloudkms.keyRings.list` - List Cloud KMS key rings

#### Cloud Scheduler Permissions
- `cloudscheduler.jobs.get` - Get Cloud Scheduler job details
- `cloudscheduler.jobs.list` - List Cloud Scheduler jobs

#### Cloud SQL Permissions
- `cloudsql.instances.get` - Get Cloud SQL instance details
- `cloudsql.instances.list` - List Cloud SQL instances

#### Compute Engine Permissions
- `compute.backendBuckets.get` - Get backend bucket details
- `compute.backendBuckets.list` - List backend buckets
- `compute.backendServices.get` - Get backend service details
- `compute.backendServices.list` - List backend services
- `compute.disks.list` - List persistent disks
- `compute.forwardingRules.list` - List forwarding rules
- `compute.healthChecks.get` - Get health check details
- `compute.healthChecks.list` - List health checks
- `compute.instances.get` - Get VM instance details
- `compute.instances.list` - List VM instances
- `compute.networks.get` - Get VPC network details
- `compute.networks.list` - List VPC networks
- `compute.regionSecurityPolicies.get` - Get regional security policy details
- `compute.regionSecurityPolicies.list` - List regional security policies
- `compute.regionSecurityPolicies.listEffectiveTags` - List effective tags on regional security policies
- `compute.regionSecurityPolicies.listTagBindings` - List tag bindings on regional security policies
- `compute.routers.list` - List Cloud Routers
- `compute.securityPolicies.get` - Get security policy details
- `compute.securityPolicies.list` - List security policies
- `compute.securityPolicies.listEffectiveTags` - List effective tags on security policies
- `compute.securityPolicies.listTagBindings` - List tag bindings on security policies
- `compute.targetHttpProxies.get` - Get HTTP proxy details
- `compute.targetHttpProxies.list` - List HTTP proxies
- `compute.targetHttpsProxies.get` - Get HTTPS proxy details
- `compute.targetHttpsProxies.list` - List HTTPS proxies
- `compute.targetPools.get` - Get target pool details
- `compute.targetPools.list` - List target pools
- `compute.targetSslProxies.get` - Get SSL proxy details
- `compute.targetSslProxies.list` - List SSL proxies
- `compute.targetTcpProxies.get` - Get TCP proxy details
- `compute.targetTcpProxies.list` - List TCP proxies
- `compute.urlMaps.list` - List URL maps

#### GKE (Kubernetes Engine) Permissions
- `container.clusters.get` - Get GKE cluster details
- `container.clusters.list` - List GKE clusters

#### Cloud DNS Permissions
- `dns.managedZones.get` - Get managed DNS zone details
- `dns.managedZones.list` - List managed DNS zones

#### Cloud Monitoring Permissions
- `monitoring.metricDescriptors.get` - Get metric descriptor details
- `monitoring.metricDescriptors.list` - List metric descriptors

#### Cloud Pub/Sub Permissions
- `pubsub.subscriptions.list` - List Pub/Sub subscriptions
- `pubsub.topics.get` - Get Pub/Sub topic details
- `pubsub.topics.list` - List Pub/Sub topics

#### Cloud Run Permissions
- `run.services.get` - Get Cloud Run service details
- `run.services.list` - List Cloud Run services

#### Cloud Storage Permissions
- `storage.buckets.list` - List Cloud Storage buckets
- `storage.objects.get` - Get Cloud Storage object details
- `storage.objects.list` - List objects in Cloud Storage buckets

---

## Permission Summary

| Category | Count | Type |
|----------|-------|------|
| Organization-Level Roles | 7 | Pre-defined Roles |
| Custom Viewer Permissions | 76 | Granular Permissions |
| **Total** | **83** | - |

---

## Access Control Details

### Service Account
- **Type**: Google Service Account
- **Scope**: Organization Level
- **Purpose**: Cross-project, multi-service monitoring and analytics

### Role Type Classification

#### Read-Only Roles
- roles/billing.viewer
- roles/recommender.viewer
- roles/apigee.analyticsViewer
- roles/apigee.readOnlyAdmin
- roles/logging.viewer
- roles/monitoring.viewer
- roles/browser

#### Custom Read-Only Permissions
All permissions in the custom viewer role are read-only (`.list` and `.get` operations only)

---

## Use Cases

1. **Billing & Cost Analysis**
   - roles/billing.viewer - Monitor organization billing

2. **API Management**
   - roles/apigee.analyticsViewer
   - roles/apigee.readOnlyAdmin
   - Monitor and analyze API usage

3. **Monitoring & Logging**
   - roles/logging.viewer
   - roles/monitoring.viewer
   - roles/browser
   - View logs and metrics across organization

4. **Infrastructure Audit**
   - custom_viewer_role_new - Comprehensive read access to all infrastructure resources

5. **Recommendations & Optimization**
   - roles/recommender.viewer - Access Google Cloud recommendations

---

## Security Notes

- All roles are read-only (no modification or deletion capabilities)
- Access is scoped at the organization level
- Custom role uses GA (General Availability) stage
- Suitable for auditing, monitoring, and reporting use cases
