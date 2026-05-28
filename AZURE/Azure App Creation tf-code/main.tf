terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "time" {}

# -----------------------------
# Create Azure AD Application 
# -----------------------------
resource "azuread_application" "finomics_app" {
  display_name = var.application_name
}

# -----------------------------
# Secret Rotation Timer
# -----------------------------
resource "time_rotating" "finomics" {
  rotation_days = var.secret_rotation_days
}

# -----------------------------
# Create Client Secret 
# -----------------------------
resource "azuread_application_password" "finomics_app_secret" {
  application_id = azuread_application.finomics_app.id
  display_name   = "${var.application_name}-secret"
  end_date       = timeadd(timestamp(), "${time_rotating.finomics.rotation_days * 24}h")

  lifecycle {
    ignore_changes = [end_date]
  }
}


# -----------------------------
# Create Service Principal 
# -----------------------------
resource "azuread_service_principal" "finomics" {
  client_id = azuread_application.finomics_app.client_id
}

# -----------------------------
# Fetch All Subscriptions
# -----------------------------
data "azurerm_subscriptions" "all" {}

locals {
  subs_map = {
    for s in data.azurerm_subscriptions.all.subscriptions :
    s.subscription_id => "/subscriptions/${s.subscription_id}"
  }
}

# -----------------------------
# Assign Roles Across All Subscriptions
# -----------------------------
resource "azurerm_role_assignment" "reader" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.finomics.object_id
}

resource "azurerm_role_assignment" "cost_reader" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Cost Management Reader"
  principal_id         = azuread_service_principal.finomics.object_id
}

resource "azurerm_role_assignment" "advisor_reader" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Advisor Reviews Reader"
  principal_id         = azuread_service_principal.finomics.object_id
}

resource "azurerm_role_assignment" "tag_contributor" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Tag Contributor"
  principal_id         = azuread_service_principal.finomics.object_id
}

