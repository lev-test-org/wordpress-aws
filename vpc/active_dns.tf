resource "aws_route53_record" "wordpress" {
  count = coalesce(var.active_dns,"null") == "null" ? 0 : 1
  zone_id = data.aws_route53_zone.lev_labs.zone_id
  name    = "active-${var.name}.lev-labs.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.active_dns]
}

data "aws_route53_zone" "lev_labs" {
  name         = "lev-labs.com."
}