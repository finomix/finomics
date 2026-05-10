module "s3" {
  source            = "../finomix-tf-modules/s3"
  bucket_name       = var.bucket_name
  environment       = var.environment
  pipeline_role_arn = var.pipeline_role_arn
  account_id        = var.account_id
  org_id            = var.org_id
}

module "iam" {
  source              = "../finomix-tf-modules/iam"
  role_name           = var.role_name
  trusted_account_arn = var.trusted_account_arn
  extra_policy_name   = var.extra_policy_name
  aws_region          = var.aws_region
  account_id          = var.account_id
}

# Enable Compute Optimizer via AWS CLI (will run during apply). This uses AWS CLI configured
# credentials on the machine running Terraform. If Terraform provider adds native support,
# consider replacing this with the provider resource.
resource "null_resource" "enable_compute_optimizer" {
  provisioner "local-exec" {
    command = "aws compute-optimizer update-enrollment-status --status Active"
  }
}
