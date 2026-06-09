terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# ------------------------------------------------------------------
# Module 1: API Enablement
# ------------------------------------------------------------------
module "api_enable" {
  source     = "./modules/api_enable"
  project_id = var.project_id
}

# ------------------------------------------------------------------
# Module 2: BigQuery Dataset
# ------------------------------------------------------------------
module "bigquery_dataset" {
  source = "./modules/bigquery_resources"

  project_id                 = var.project_id
  dataset_id                 = var.dataset_id
  location                   = var.dataset_location
  description                = var.dataset_description
  delete_contents_on_destroy = var.delete_contents_on_destroy

  depends_on = [module.api_enable]
}

# ------------------------------------------------------------------
# Module 3: Service Account and Org Permissions
# Creates SA and grants org-level permissions
# ------------------------------------------------------------------
module "service_account" {
  source = "./modules/service_account"

  project_id      = var.project_id
  organization_id = var.organization_id
  sa_name         = var.sa_name
  sa_display_name = var.sa_display_name

  depends_on = [module.api_enable]
}

# ------------------------------------------------------------------
# Grant READ access to THIS BigQuery Dataset ONLY
# This service account can ONLY read this specific dataset and its tables
# ------------------------------------------------------------------
resource "google_bigquery_dataset_iam_member" "dataset_reader" {
  dataset_id = var.dataset_id
  project    = var.project_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${module.service_account.service_account_email}"

  depends_on = [module.service_account, module.bigquery_dataset]
}

# ------------------------------------------------------------------
# Grant Job User Permission at PROJECT Level
# Allows running queries (bigquery.jobUser is project-level only)
# ------------------------------------------------------------------
resource "google_project_iam_member" "project_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${module.service_account.service_account_email}"

  depends_on = [module.service_account, module.api_enable]
}

# ------------------------------------------------------------------
# Grant Read Sessions Create Permission at PROJECT Level
# Allows creating read sessions for efficient data reading
# ------------------------------------------------------------------
resource "google_project_iam_member" "project_read_sessions" {
  project = var.project_id
  role    = "roles/bigquery.readSessionUser"
  member  = "serviceAccount:${module.service_account.service_account_email}"

  depends_on = [module.service_account, module.api_enable]
}

# ------------------------------------------------------------------
# Grant BigQuery Data Viewer Permission at PROJECT Level
# Allows viewing BigQuery datasets and tables across the project
# ------------------------------------------------------------------
resource "google_project_iam_member" "project_bigquery_data_viewer" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${module.service_account.service_account_email}"

  depends_on = [module.service_account, module.api_enable]
}
