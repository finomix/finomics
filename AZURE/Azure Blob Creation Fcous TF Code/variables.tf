variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account (must be globally unique)"
}

variable "container_name" {
  type        = string
  description = "Name of the Blob container"
}

variable "app_client_id" {
  type        = string
  description = "The Client ID (Application ID) of the App Registration"
}
