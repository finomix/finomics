variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region for resources."
  type        = string
}

variable "organization_id" {
  description = "GCP Organization ID for org-level permissions."
  type        = string
}

# ------------------------------------------------------------------
# BigQuery Dataset Variables
# ------------------------------------------------------------------
variable "dataset_id" {
  description = "BigQuery dataset ID to create."
  type        = string
}

variable "dataset_location" {
  description = "Location of BigQuery dataset."
  type        = string
}

variable "dataset_description" {
  description = "Description of the BigQuery dataset."
  type        = string
}

variable "delete_contents_on_destroy" {
  description = "Delete all contents when destroying the dataset."
  type        = bool
}

# ------------------------------------------------------------------
# Service Account Variables
# ------------------------------------------------------------------
variable "sa_name" {
  description = "Service account ID (without domain)."
  type        = string
}

variable "sa_display_name" {
  description = "Display name for the service account."
  type        = string
}
