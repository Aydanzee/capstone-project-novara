resource "aws_route53_zone" "this" {
  count = var.create_hosted_zone ? 1 : 0

  name = var.domain_name

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}

resource "aws_route53_record" "extra" {
  for_each = var.create_hosted_zone ? {
    for record in var.extra_records : "${record.name}-${record.type}" => record
  } : {}

  zone_id         = aws_route53_zone.this[0].zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = each.value.ttl
  records         = each.value.records
  allow_overwrite = true
}
