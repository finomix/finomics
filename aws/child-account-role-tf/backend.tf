terraform {
  backend "s3" {
    bucket         = "" ## bucket where statefile will be store and manage
    key            = "" ## bucket path where state file will be stored and managed
    region         = "us-east-1" ## bucket region
  }
}