module "finomics_access_role" {
  source = "./modules"
  role_name         = ""
  trusted_account   = "364582896484" ##finomics Account id 
  trusted_role_arn  = "arn:aws:iam::364582896484:role/finomics_data_pipeline_role" ## finomics trusted role ARN
  account_id        = "" ##herbalife child account id 
}
