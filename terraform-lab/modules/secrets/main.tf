# 1. RDS Secret
resource "aws_secretsmanager_secret" "db_creds" {
  name        = "production/rails-app/db-creds-v2"
  description = "RDS database credentials for Rails app (V2)"
  
  # This allows terraform to recreate it quickly during testing
  recovery_window_in_days = 0 
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    engine   = "postgres"
    host     = var.rds_endpoint
    port     = 5432
    dbname   = "hello_world_production"
  })
}

# 2. App Secrets
resource "aws_secretsmanager_secret" "app_secrets" {
  name        = "production/rails-app/app-secrets-v2"
  description = "Application secrets for Rails app (V2)"
  
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id     = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    SECRET_KEY_BASE = var.secret_key_base
  })
}
