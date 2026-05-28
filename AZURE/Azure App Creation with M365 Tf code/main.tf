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

# --------------------------------
# Create Azure AD Application
# --------------------------------
resource "azuread_application" "finomics_app" {
  display_name = var.application_name
}

# --------------------------------
# Secret Rotation Timer
# --------------------------------
resource "time_rotating" "finomics" {
  rotation_days = var.secret_rotation_days
}

# --------------------------------
# Create Client Secret
# --------------------------------
resource "azuread_application_password" "finomics_app_secret" {
  application_id = azuread_application.finomics_app.id
  display_name   = "${var.application_name}-secret"

  end_date = timeadd(
    timestamp(),
    "${time_rotating.finomics.rotation_days * 24}h"
  )

  lifecycle {
    ignore_changes = [end_date]
  }
}

# --------------------------------
# Create Service Principal
# --------------------------------
resource "azuread_service_principal" "finomics" {
  client_id = azuread_application.finomics_app.client_id
}

# --------------------------------
# Wait for SP propagation
# --------------------------------
resource "time_sleep" "wait_for_sp" {
  depends_on      = [azuread_service_principal.finomics]
  create_duration = "20s"
}

# --------------------------------
# Microsoft Graph Service Principal
# --------------------------------
data "azuread_service_principal" "msgraph" {
  display_name = "Microsoft Graph"
}

# --------------------------------
# Assign Microsoft Graph API Permissions
# --------------------------------
resource "azuread_app_role_assignment" "graph_permissions" {

  depends_on = [time_sleep.wait_for_sp]

  for_each = {
    Directory_Read_All    = data.azuread_service_principal.msgraph.app_role_ids["Directory.Read.All"]
    Group_Read_All        = data.azuread_service_principal.msgraph.app_role_ids["Group.Read.All"]
    Organization_Read_All = data.azuread_service_principal.msgraph.app_role_ids["Organization.Read.All"]
    Reports_Read_All      = data.azuread_service_principal.msgraph.app_role_ids["Reports.Read.All"]
  }

  app_role_id         = each.value
  principal_object_id = azuread_service_principal.finomics.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

# --------------------------------
# Fetch All Subscriptions
# --------------------------------
data "azurerm_subscriptions" "all" {}

locals {
  subs_map = {
    for s in data.azurerm_subscriptions.all.subscriptions :
    s.subscription_id => "/subscriptions/${s.subscription_id}"
  }
}

# --------------------------------
# Assign Reader Role
# --------------------------------
resource "azurerm_role_assignment" "reader" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.finomics.object_id
}

# --------------------------------
# Assign Cost Management Reader
# --------------------------------
resource "azurerm_role_assignment" "cost_reader" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Cost Management Reader"
  principal_id         = azuread_service_principal.finomics.object_id
}

# --------------------------------
# Assign Advisor Reviews Reader
# --------------------------------
resource "azurerm_role_assignment" "advisor_reader" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Advisor Reviews Reader"
  principal_id         = azuread_service_principal.finomics.object_id
}

# --------------------------------
# Assign Tag Contributor
# --------------------------------
resource "azurerm_role_assignment" "tag_contributor" {
  for_each             = local.subs_map
  scope                = each.value
  role_definition_name = "Tag Contributor"
  principal_id         = azuread_service_principal.finomics.object_id
}