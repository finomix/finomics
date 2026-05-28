output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "container_name" {
  value = azurerm_storage_container.container.name
}

output "connection_string" {
  value     = azurerm_storage_account.sa.primary_connection_string
  sensitive = true
}
