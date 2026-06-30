output "zone_id" {
  description = "The ID of the Route 53 Hosted Zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "The name servers for the Hosted Zone"
  value       = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  description = "The ARN of the validated SSL certificate"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}
