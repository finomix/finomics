output "application_object_id" {
  description = "Azure AD Application Object ID"
  value       = azuread_application.finomics_app.id
}

output "client_id" {
  description = "Application (Client) ID"
  value       = azuread_application.finomics_app.application_id
}

output "client_secret" {
  description = "Client Secret Value"
  sensitive   = true
  value       = azuread_application_password.finomics_app_secret.value
}

output "service_principal_object_id" {
  description = "Service Principal Object ID"
  value       = azuread_service_principal.finomics.object_id
}
