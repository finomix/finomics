output "dataset_id" {
  description = "BigQuery dataset ID used for access binding."
  value       = var.dataset_id
}

output "dataset_full_id" {
  description = "Full BigQuery dataset ID (project:dataset)."
  value       = "${var.project_id}:${var.dataset_id}"
}

output "service_account_email" {
  description = "Email of the created service account."
  value       = module.service_account.service_account_email
}

output "permissions_summary" {
  description = "Summary of permissions granted to the service account."
  value = {
    bigquery_dataset_access      = "roles/bigquery.dataViewer on ${var.dataset_id}"
    bigquery_project_dataviewer  = "roles/bigquery.dataViewer on project ${var.project_id}"
    bigquery_project_jobuser     = "roles/bigquery.jobUser on project ${var.project_id}"
    bigquery_project_readsession = "roles/bigquery.readSessionUser on project ${var.project_id}"
    organization_browser         = "roles/browser on org ${var.organization_id}"
    organization_recommender     = "roles/recommender.viewer on org ${var.organization_id}"
    organization_billing         = "roles/billing.viewer on org ${var.organization_id}"
    organization_apigee_analytics = "roles/apigee.analyticsViewer on org ${var.organization_id}"
    organization_apigee_readonly = "roles/apigee.readOnlyAdmin on org ${var.organization_id}"
    organization_logs_viewer     = "roles/logging.viewer on org ${var.organization_id}"
    organization_monitoring      = "roles/monitoring.viewer on org ${var.organization_id}"
    organization_custom_viewer   = "custom_viewer_role_new on org ${var.organization_id}"
  }
}

