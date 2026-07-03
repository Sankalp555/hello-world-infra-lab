output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}
