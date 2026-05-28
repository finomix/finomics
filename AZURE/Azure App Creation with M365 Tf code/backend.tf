terraform {
  backend "azurerm" {
    resource_group_name  = "finomics-terraform-state-rg"
    storage_account_name = "finomicsfstatebucket99090"
    container_name       = "finomicsstate"
    key                  = "prod-1/terraform.tfstate"
  }
}