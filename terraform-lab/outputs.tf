output "instance_id" {
  description = "ID of the EC2 instance (Deprecated for ASG)"
  value       = "ASG Managed"
}

output "instance_public_ip" {
  description = "The fixed Elastic IP address (Deprecated for ASG)"
  value       = "ALB Managed"
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "name_servers" {
  description = "The name servers for the Hosted Zone"
  value       = module.dns.name_servers
}

output "certificate_arn" {
  description = "The ARN of the SSL certificate"
  value       = module.dns.certificate_arn
}
