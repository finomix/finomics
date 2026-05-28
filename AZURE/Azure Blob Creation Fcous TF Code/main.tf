terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

# Providers
provider "azurerm" {
  features {}
}

provider "azuread" {
  # will use env vars
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account with HNS enabled (ADLS Gen2)
resource "azurerm_storage_account" "sa" {
  name                       = var.storage_account_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Standard"
  account_replication_type   = "RAGRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  is_hns_enabled             = true
}

# Container (Filesystem)
resource "azurerm_storage_container" "container" {
  name                   = var.container_name
  storage_account_id     = azurerm_storage_account.sa.id
  container_access_type  = "private"
}

# Lookup Service Principal for your App Registration
data "azuread_service_principal" "app_sp" {
  client_id = var.app_client_id
}

# RBAC: Assign "Storage Blob Data Reader" 
resource "azurerm_role_assignment" "blob_data_reader" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azuread_service_principal.app_sp.object_id
}


# ----------------------------------------------
# ACL: Recursive ACLs for ADLS Gen2 (BEST PRACTICE)
# ----------------------------------------------
resource "azurerm_storage_data_lake_gen2_path" "focus" {
  path               = "focus"
  filesystem_name    = azurerm_storage_container.container.name
  storage_account_id = azurerm_storage_account.sa.id
  resource           = "directory"

  # User (your Service Principal)
  ace {
    type        = "user"
    id          = data.azuread_service_principal.app_sp.object_id
    permissions = "r-x"
    scope       = "access"
  }

  # Default inheritance for new children (allowed)
  ace {
    type        = "user"
    id          = data.azuread_service_principal.app_sp.object_id
    permissions = "r-x"
    scope       = "default"
  }

  # Group
  ace {
    type        = "group"
    permissions = "r-x"
    scope       = "access"
  }

  ace {
    type        = "group"
    permissions = "r-x"
    scope       = "default"
  }

  # Other
  ace {
    type        = "other"
    permissions = "---"
    scope       = "access"
  }

  ace {
    type        = "other"
    permissions = "---"
    scope       = "default"
  }
}

