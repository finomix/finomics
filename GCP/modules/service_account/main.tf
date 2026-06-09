# ------------------------------------------------------------------
# Create Service Account
# ------------------------------------------------------------------
resource "google_service_account" "sa" {
  account_id   = var.sa_name
  display_name = var.sa_display_name
  project      = var.project_id
}

# ------------------------------------------------------------------
# Grant Billing Viewer Permission at Organization Level
# Allows read-only visibility into billing data across the org
# ------------------------------------------------------------------
resource "google_organization_iam_member" "billing_viewer" {
  org_id = var.organization_id
  role   = "roles/billing.viewer"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Grant Recommender Viewer Permission at Organization Level
# Allows viewing recommendations across the organization
# ------------------------------------------------------------------
resource "google_organization_iam_member" "recommender_viewer" {
  org_id = var.organization_id
  role   = "roles/recommender.viewer"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Grant Apigee Analytics Viewer Permission at Organization Level
# ------------------------------------------------------------------
resource "google_organization_iam_member" "apigee_analytics_viewer" {
  org_id = var.organization_id
  role   = "roles/apigee.analyticsViewer"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Grant Apigee Read-only Admin Permission at Organization Level
# ------------------------------------------------------------------
resource "google_organization_iam_member" "apigee_readonly_admin" {
  org_id = var.organization_id
  role   = "roles/apigee.readOnlyAdmin"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Grant Logs Viewer Permission at Organization Level
# ------------------------------------------------------------------
resource "google_organization_iam_member" "logs_viewer" {
  org_id = var.organization_id
  role   = "roles/logging.viewer"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Grant Monitoring Viewer Permission at Organization Level
# ------------------------------------------------------------------
resource "google_organization_iam_member" "monitoring_viewer" {
  org_id = var.organization_id
  role   = "roles/monitoring.viewer"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Grant Browser Permission at Organization Level
# ------------------------------------------------------------------
resource "google_organization_iam_member" "browser" {
  org_id = var.organization_id
  role   = "roles/browser"
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

# ------------------------------------------------------------------
# Custom Organization IAM Role
# Unified viewer role for multi-service read access at org level
# ------------------------------------------------------------------
resource "google_organization_iam_custom_role" "custom_viewer_role" {
  org_id      = var.organization_id
  role_id     = "custom_viewer_role_new"
  title       = "Custom Viewer Role"
  description = "Unified viewer role for multi-service read access"
  stage       = "GA"

  permissions = [
    "aiplatform.endpoints.list",
    "aiplatform.locations.list",
    "aiplatform.models.list",
    "aiplatform.pipelineJobs.list",
    "aiplatform.trainingPipelines.list",
    "artifactregistry.locations.list",
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.list",
    "bigtable.instances.get",
    "bigtable.instances.list",
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",
    "cloudfunctions.functions.get",
    "cloudfunctions.functions.list",
    "cloudkms.cryptoKeyVersions.get",
    "cloudkms.cryptoKeyVersions.list",
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeys.list",
    "cloudkms.keyRings.get",
    "cloudkms.keyRings.list",
    "cloudscheduler.jobs.get",
    "cloudscheduler.jobs.list",
    "cloudsql.instances.get",
    "cloudsql.instances.list",
    "compute.backendBuckets.get",
    "compute.backendBuckets.list",
    "compute.backendServices.get",
    "compute.backendServices.list",
    "compute.disks.list",
    "compute.forwardingRules.list",
    "compute.healthChecks.get",
    "compute.healthChecks.list",
    "compute.instances.get",
    "compute.instances.list",
    "compute.networks.get",
    "compute.networks.list",
    "compute.regionSecurityPolicies.get",
    "compute.regionSecurityPolicies.list",
    "compute.regionSecurityPolicies.listEffectiveTags",
    "compute.regionSecurityPolicies.listTagBindings",
    "compute.routers.list",
    "compute.securityPolicies.get",
    "compute.securityPolicies.list",
    "compute.securityPolicies.listEffectiveTags",
    "compute.securityPolicies.listTagBindings",
    "compute.targetHttpProxies.get",
    "compute.targetHttpProxies.list",
    "compute.targetHttpsProxies.get",
    "compute.targetHttpsProxies.list",
    "compute.targetPools.get",
    "compute.targetPools.list",
    "compute.targetSslProxies.get",
    "compute.targetSslProxies.list",
    "compute.targetTcpProxies.get",
    "compute.targetTcpProxies.list",
    "compute.urlMaps.list",
    "container.clusters.get",
    "container.clusters.list",
    "dns.managedZones.get",
    "dns.managedZones.list",
    "monitoring.metricDescriptors.get",
    "monitoring.metricDescriptors.list",
    "pubsub.subscriptions.list",
    "pubsub.topics.get",
    "pubsub.topics.list",
    "run.services.get",
    "run.services.list",
    "storage.buckets.list",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

# ------------------------------------------------------------------
# Bind Custom Org Role to the Service Account
# ------------------------------------------------------------------
resource "google_organization_iam_member" "sa_custom_viewer_binding" {
  org_id = var.organization_id
  role   = google_organization_iam_custom_role.custom_viewer_role.id
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa, google_organization_iam_custom_role.custom_viewer_role]
}
