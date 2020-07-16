variable elb_dns_name {}

variable elb_zone_id {}

variable dns_name {}

variable dns_zone {}

data aws_route53_zone dns {
  name = var.dns_zone
}

resource aws_route53_record www {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = var.elb_dns_name
    zone_id                = var.elb_zone_id
    evaluate_target_health = true
  }
}