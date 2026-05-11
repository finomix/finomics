terraform {
  backend "s3" {
    bucket         = "finomics-aws-terraform-pov-new-statefile"
    key            = "terraform-2/state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
