# Application name
variable "application_name" {
  description = "The display name of the Azure AD application"
  type        = string
}

# Secret rotation in days
variable "secret_rotation_days" {
  description = "Number of days after which the application secret rotates"
  type        = number
}
