output "zone_id" {
  description = "Route53 hosted zone ID."
  value       = try(aws_route53_zone.this[0].zone_id, null)
}

output "name_servers" {
  description = "Route53 hosted zone name servers for registrar delegation."
  value       = try(aws_route53_zone.this[0].name_servers, [])
}
