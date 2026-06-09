# -------------------------------
# BigQuery Dataset
# -------------------------------
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  project                     = var.project_id
  location                    = var.location
  description                 = var.description
  delete_contents_on_destroy  = var.delete_contents_on_destroy
}

# -------------------------------
# IAM Binding for Service Account
# -------------------------------
resource "google_bigquery_dataset_iam_member" "dataset_access" {
  for_each = var.dataset_access

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id
  role       = each.value.role
  member = "serviceAccount:${each.value.member}"


}