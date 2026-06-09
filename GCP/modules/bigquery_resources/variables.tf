variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "herbalife-project"
}

variable "dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
}

variable "location" {
  description = "Location of BigQuery dataset"
  type        = string
  default     = "US"
}

variable "description" {
  description = "Dataset description"
  type        = string
  default     = "Dataset for billing export and focus reporting."
}

variable "delete_contents_on_destroy" {
  description = "Delete all contents on destroy"
  type        = bool
  default     = false
}

# -------------------------------
# IAM Bindings for Dataset
# Example:
# dataset_access = {
#   view_sa = { role = "roles/bigquery.dataViewer", member = "module.sa_recommender.service_account_email"}
# }
# -------------------------------
variable "dataset_access" {
  description = "IAM bindings for dataset"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}

variable "depends_on_sa" {
  description = "Dependency to ensure service account is created before IAM bindings"
  type        = any
  default     = null
}
