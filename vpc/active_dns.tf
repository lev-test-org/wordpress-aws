resource "aws_route53_record" "wordpress" {
  count = var.active_dns ? 1 : 0
  zone_id = data.aws_route53_zone.lev_labs.zone_id
  name    = "active-${var.name}.lev-labs.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.active_dns]
}

data "aws_route53_zone" "lev_labs" {
  name         = "lev-labs.com."
}