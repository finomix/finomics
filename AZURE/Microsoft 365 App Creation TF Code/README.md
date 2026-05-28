# Microsoft 365 App Creation - Terraform

## 📌 Overview

This Terraform module automates the creation of a Microsoft 365 (M365) Azure AD Application with Graph API permissions and a Service Principal.

The module provisions:

- Azure AD Application
- Service Principal
- Client Secret (with automatic rotation)
- Microsoft Graph API Permission Assignments:
  - `Directory.Read.All`
  - `Group.Read.All`
  - `Organization.Read.All`
  - `Reports.Read.All`

> This module creates only the **App Registration, Service Principal, and M365 Graph permissions**. It does not assign Azure subscription-level roles (Reader, Cost Management Reader, etc.). Use the Azure App Creation module for that.

---

## 📁 Folder Structure

```
├── main.tf            # Core resources: App, SP, secret, Graph permission assignments
├── variables.tf       # Input variable definitions
├── terraform.tfvars   # Variable values (application name, secret rotation)
├── output.tf          # Outputs: client ID, secret, SP object ID, permissions
├── backend.tf         # Remote state configuration (Azure Storage)
└── README.md          # This file
```

---

## 🔐 Microsoft Graph API Permissions Assigned

The following **application-level** Microsoft Graph permissions are granted to the Service Principal:

| Permission              | Description                   |
|-------------------------|-------------------------------|
| `Directory.Read.All`    | Read all directory data        |
| `Group.Read.All`        | Read all groups                |
| `Organization.Read.All` | Read organization information  |
| `Reports.Read.All`      | Read all usage reports         |

> Permissions are assigned via `azuread_app_role_assignment` using the Microsoft Graph service principal.

---

## 🔧 Provider Versions

| Provider  | Version   | Purpose                                   |
|-----------|-----------|-------------------------------------------|
| `azuread` | `~> 2.47` | App & Service Principal creation          |
| `azurerm` | `~> 3.0`  | Azure Resource Manager                    |
| `time`    | `~> 0.9`  | Secret expiration and rotation            |

**Terraform version:** `>= 1.5.0`

---

## 🗄️ Backend Configuration (backend.tf)

State is stored remotely in an Azure Storage Account. The following resources **must already exist** before running Terraform:

| Resource           | Value                         |
|--------------------|-------------------------------|
| Resource Group     | `finomics-terraform-state`    |
| Storage Account    | `finomicsfstatebucket99090`   |
| Storage Container  | `finomicsstate`               |
| State Key          | `prod-5/terraform.tfstate`    |

---

## 📝 Variables

| Variable               | Type   | Description                                      | Default (tfvars)      |
|------------------------|--------|--------------------------------------------------|-----------------------|
| `application_name`     | string | Display name of the Azure AD application         | `finomics-m365-app`   |
| `secret_rotation_days` | number | Number of days before the client secret rotates  | `730`                 |

---

## 📤 Outputs

| Output                       | Description                          | Sensitive |
|------------------------------|--------------------------------------|-----------|
| `application_object_id`      | Azure AD Application Object ID       | No        |
| `client_id`                  | Application (Client) ID              | No        |
| `client_secret`              | Client Secret Value                  | ✅ Yes    |
| `service_principal_object_id`| Service Principal Object ID          | No        |
| `assigned_permissions`       | List of Graph permissions assigned   | No        |

> The `client_secret` is marked sensitive and will not appear in terminal output.  
> To retrieve it, run:
> ```bash
> terraform output -raw client_secret
> ```

---

## 🔑 CI/CD Pipeline Variables

Add the following as secret variables in your CI/CD pipeline:

| Variable              | Description                        |
|-----------------------|------------------------------------|
| `ARM_CLIENT_ID`       | Service Principal Client ID        |
| `ARM_CLIENT_SECRET`   | Service Principal Client Secret    |
| `ARM_SUBSCRIPTION_ID` | Your primary Azure Subscription ID |
| `ARM_TENANT_ID`       | Azure Active Directory Tenant ID   |

> Use the same variable names as defined in the pipeline configuration. Refer to the onboarding document before running the pipeline.

---

## 🚀 How to Run Terraform

```bash
# 1. Initialize Terraform and download providers
terraform init

# 2. Preview the changes
terraform plan -out=tfplan

# 3. Apply the changes
terraform apply -auto-approve tfplan
```

---

## ⚠️ Notes

- A **20-second wait** (`time_sleep`) is built in after Service Principal creation to allow Azure AD propagation before assigning Graph permissions.
- The `secret_rotation_days` value in `terraform.tfvars` is set to `730` (2 years). Adjust as needed per your security policy.
- The account running Terraform must have sufficient privileges to create app registrations and assign Microsoft Graph application roles in Azure Entra ID.
