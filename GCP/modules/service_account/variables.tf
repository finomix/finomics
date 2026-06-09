variable "project_id" {
  description = "The GCP project ID where the service account will be created."
  type        = string
}

variable "organization_id" {
  description = "The GCP organization ID for granting organization-level permissions."
  type        = string
}

variable "sa_name" {
  description = "Service account ID (without domain)."
  type        = string
}

variable "sa_display_name" {
  description = "Display name for the service account."
  type        = string
}