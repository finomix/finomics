# GCP Terraform Configuration Variables
# Update these values according to your specific environment

# GCP Project Configuration
project_id = "your-project"
region     = "us-central1"

# Organization Configuration
organization_id = "123456789012"

# BigQuery Dataset Configuration
dataset_id                 = "your-dataset"
dataset_location           = "US"
dataset_description        = "Dataset for finomics billing and analytics data-new."
delete_contents_on_destroy = false

# Service Account Configuration
sa_name          = "finomics-reader-sa-v2-new"
sa_display_name  = "Finomics Dataset Reader Service Account v2-new"
