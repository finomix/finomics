terraform {
  backend "gcs" {
    bucket = "gcs-herbalife-statefile-bucket-new"
    prefix = "terraform/state"
  }
}
