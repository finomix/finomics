variable "application_name" {
  description = "Azure AD Application Name"
  type        = string
}

# Secret rotation in days
variable "secret_rotation_days" {
  description = "Number of days after which the application secret rotates"
  type        = number
}

