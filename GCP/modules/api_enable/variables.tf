variable "project_id" {
  description = "The ID of the GCP project where APIs need to be enabled."
  type        = string
  default     = "herbalife-project"
}

variable "apis" {
  description = "List of APIs to enable for the project."
  type        = list(string)
  default     = [
    "bigquery.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "recommender.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com"
  ]
}
