output "service_account_email" {
  description = "Email of the created service account."
  value       = google_service_account.sa.email
}

output "service_account_name" {
  description = "Full name of the service account."
  value       = google_service_account.sa.name
}
