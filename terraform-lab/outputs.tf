output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.my_web_server.instance_id
}

output "instance_public_ip" {
  description = "The fixed Elastic IP address"
  value       = aws_eip.app_eip.public_ip
}

output "name_servers" {
  description = "The name servers for the Hosted Zone"
  value       = module.dns.name_servers
}

output "certificate_arn" {
  description = "The ARN of the SSL certificate"
  value       = module.dns.certificate_arn
}
