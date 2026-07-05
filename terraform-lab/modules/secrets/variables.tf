variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "db_password" {
  description = "Database password to store in secret"
  type        = string
  sensitive   = true
}

variable "secret_key_base" {
  description = "Rails secret key base to store in secret"
  type        = string
  sensitive   = true
}

variable "rds_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "db_username" {
  description = "RDS username"
  type        = string
  default     = "postgres"
}
