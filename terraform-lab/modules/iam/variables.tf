variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "secret_path" {
  description = "Path for the secrets in Secrets Manager"
  type        = string
  default     = "production/rails-app"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}
